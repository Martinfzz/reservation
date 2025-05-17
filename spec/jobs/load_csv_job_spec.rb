require 'rails_helper'
require 'tempfile'

RSpec.describe LoadCsvJob, type: :job do
  let(:import_job) { ImportJob.create!(status: :pending, total_rows: 0, processed_rows: 0) }
  let(:mapping) do
    Imports::CsvColumnMapper::EXPECTED_COLUMNS.keys.index_with { |key| key.to_s.upcase }
  end

  let(:csv_content) do
    <<~CSV
      TICKET_NUMBER,RESERVATION_REFERENCE,RESERVATION_DATE
      123,ABC,2023-01-01
      456,DEF,2023-01-02
    CSV
  end

  let(:csv_file) do
    file = Tempfile.new([ 'test', '.csv' ])
    file.write(csv_content)
    file.rewind
    file
  end

  after do
    csv_file.close
    csv_file.unlink
  end

  before do
    allow(Imports::CsvColumnMapper).to receive(:detect_separator).and_return(',')
    allow(ProcessImportJob).to receive(:perform_async)
  end

  it 'imports rows and updates ImportJob' do
    expect {
      described_class.new.perform(csv_file.path, import_job.id, mapping)
    }.to change { RawImportRow.count }.by(2)

    import_job.reload
    expect(import_job.status).to eq('pending')
    expect(import_job.total_rows).to eq(2)
    expect(import_job.processed_rows).to eq(0)
  end

  it 'inserts rows in batches' do
    stub_const("LoadCsvJob::BATCH_SIZE", 1) # Force batch size to 1 to test batching

    expect(RawImportRow).to receive(:insert_all).at_least(:twice).and_call_original

    described_class.new.perform(csv_file.path, import_job.id, mapping)
  end

  it 'enqueues ProcessImportJob after import' do
    expect(ProcessImportJob).to receive(:perform_async).with(import_job.id, 0)
    described_class.new.perform(csv_file.path, import_job.id, mapping)
  end

  it 'deletes the CSV file after processing' do
    path = csv_file.path
    described_class.new.perform(path, import_job.id, mapping)
    expect(File.exist?(path)).to be_falsey
  end

  context 'when the file does not exist' do
    it 'raises error and does not delete non-existent file' do
      non_existent_path = '/tmp/non_existent.csv'

      expect(File).not_to receive(:delete)

      expect {
        described_class.new.perform(non_existent_path, import_job.id, mapping)
      }.to raise_error(Errno::ENOENT)
    end
  end
end
