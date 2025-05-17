require "rails_helper"

RSpec.describe ProcessImportJob, type: :job do
  let(:import_job) { ImportJob.create!(status: :pending, total_rows: 0, processed_rows: 0) }
  let!(:raw_import_rows) { create_list(:raw_import_row, 2, import_job: import_job) }

  subject { described_class.new }

  before do
    allow(ProcessImportJob).to receive(:perform_async)
  end

  describe "#perform" do
    context "when there are rows to process" do
      it "processes rows and increments processed_rows" do
        expect {
          subject.perform(import_job.id, 0)
        }.to change { import_job.reload.processed_rows }.by(2)

        expect(import_job.reload.status).to eq("processing")

        expect(Buyer.count).to eq(2)
        expect(Show.count).to eq(2)
        expect(Performance.count).to eq(2)
        expect(Booking.count).to eq(2)

        expect(RawImportRow.where(import_job: import_job)).to be_empty
      end

      it "enqueues next batch job with increased offset" do
        subject.perform(import_job.id, 0)

        expect(ProcessImportJob).to have_received(:perform_async).with(import_job.id, ProcessImportJob::BATCH_SIZE)
      end
    end

    context "when no rows left to process" do
      it "marks the import job as completed" do
        RawImportRow.where(import_job: import_job).delete_all

        subject.perform(import_job.id, 0)

        expect(Buyer.count).to eq(0)
        expect(Show.count).to eq(0)
        expect(Performance.count).to eq(0)
        expect(Booking.count).to eq(0)

        expect(import_job.reload.status).to eq("completed")
      end
    end

    context "when an error occurs" do
      before do
        allow_any_instance_of(ProcessImportJob).to receive(:find_or_create_buyer).and_raise(StandardError, "Error")
      end

      it "marks the job as failed and logs the error" do
        subject.perform(import_job.id, 0)

        import_job.reload
        expect(import_job.status).to eq("failed")
        expect(import_job.error_log).to include("StandardError: Error")
      end
    end

    context "when raw data is invalid" do
      before do
        RawImportRow.destroy_all
        RawImportRow.create!(
          import_job: import_job,
          data: {
            "first_name" => "Jane",
            "last_name" => "Doe",
            # "email" => nil, # required field missing
            "ticket_number" => "TICKET123",
            "external_id_show" => "SHOW123",
            "title_show" => "Sample Show",
            "external_id_perf" => "PERF123",
            "title_perf" => "Sample Perf",
            "start_date" => "2024-01-01",
            "start_time" => "10:00",
            "end_date" => "2024-01-01",
            "end_time" => "12:00",
            "reservation_reference" => "RES123",
            "reservation_date" => "2024-01-01",
            "reservation_time" => "09:00",
            "price" => "30.0",
            "product_type" => "ticket",
            "sales_channel" => "online",
            "address" => "123 street",
            "postal_code" => "75000",
            "country" => "France",
            "age" => 25,
            "gender" => "F"
          }
        )
      end

      it "marks the job as failed and logs the error" do
        subject.perform(import_job.id, 0)

        import_job.reload
        expect(import_job.status).to eq("failed")
        expect(import_job.error_log).to include("ActiveRecord::RecordInvalid")
        expect(Buyer.count).to eq(0)
        expect(Booking.count).to eq(0)
        expect(Show.count).to eq(0)
        expect(Performance.count).to eq(0)
      end
    end
  end
end
