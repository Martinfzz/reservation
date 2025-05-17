class LoadCsvJob
  include Sidekiq::Job
  require "csv"

  BATCH_SIZE = 1000

  def perform(filepath, import_job_id, mapping)
    job = ImportJob.find(import_job_id)
    job.update(status: :pending)

    count = import_csv_rows(filepath, import_job_id, mapping)

    job.update(total_rows: count, processed_rows: 0)
    ProcessImportJob.perform_async(import_job_id, 0)
  ensure
    File.delete(filepath) if File.exist?(filepath)
  end

  private

  def import_csv_rows(filepath, import_job_id, mapping)
    rows = []
    count = 0

    CSV.foreach(filepath, headers: true, col_sep: Imports::CsvColumnMapper.detect_separator(filepath)) do |row|
      mapped_data = Imports::CsvColumnMapper.map_headers(row, mapping)
      next if mapped_data.empty?

      rows << { import_job_id: import_job_id, data: mapped_data }
      count += 1

      if rows.size >= BATCH_SIZE
        RawImportRow.insert_all(rows)
        rows.clear
      end
    end

    RawImportRow.insert_all(rows) unless rows.empty?
    count
  end
end
