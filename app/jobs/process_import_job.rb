class ProcessImportJob
  include Sidekiq::Job

  BATCH_SIZE = 1000

  def perform(import_job_id, offset = 0)
    job = ImportJob.find(import_job_id)
    job.update(status: :processing)

    rows = RawImportRow.where(import_job_id: import_job_id).offset(offset).limit(BATCH_SIZE)
    return job.update(status: :completed) if rows.empty?

    rows.each do |raw_row|
      data = raw_row.data

      ActiveRecord::Base.transaction do
        buyer = find_or_create_buyer(data)
        show = find_or_create_show(data)
        performance = find_or_create_performance(data, show)
        find_or_create_booking(data, buyer, performance)
      end

      job.increment!(:processed_rows)
    end


    rows.destroy_all

    ProcessImportJob.perform_async(import_job_id, offset + BATCH_SIZE)
  rescue => e
    job.update(status: :failed, error_log: "#{e.class}: #{e.message}")
  end

  private

  def capitalize_name(name)
    name.split("-").map(&:capitalize).join("-")
  end

  def find_or_create_buyer(data)
    Buyer.find_or_create_by!(email: data["email"]&.downcase) do |b|
      b.first_name = capitalize_name(data["first_name"])
      b.last_name = capitalize_name(data["last_name"])
      b.address = data["address"]&.capitalize
      b.postal_code = data["postal_code"]&.to_i
      b.country = capitalize_name(data["country"])
      b.age = data["age"]&.to_i
      b.gender = data["gender"]
    end
  end

  def find_or_create_show(data)
    Show.find_or_create_by!(external_id: data["external_id_show"]&.to_i) do |s|
      s.title = data["title_show"]&.capitalize
    end
  end

  def find_or_create_performance(data, show)
    Performance.find_or_create_by!(external_id: data["external_id_perf"]&.to_i) do |p|
      p.title = data["title_perf"]&.capitalize
      p.start_date = data["start_date"]
      p.start_time = data["start_time"]
      p.end_date = data["end_date"]
      p.end_time = data["end_time"]
      p.show = show
    end
  end

  def find_or_create_booking(data, buyer, performance)
    Booking.find_or_create_by!(ticket_number: data["ticket_number"]&.to_i) do |b|
      b.reservation_reference = data["reservation_reference"]&.to_i
      b.reservation_date = data["reservation_date"]
      b.reservation_time = data["reservation_time"]
      b.price = data["price"]&.to_f
      b.product_type = data["product_type"]&.capitalize
      b.sales_channel = data["sales_channel"]&.capitalize
      b.buyer = buyer
      b.performance = performance
    end
  end
end
