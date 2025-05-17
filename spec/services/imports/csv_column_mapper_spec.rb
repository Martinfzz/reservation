require 'rails_helper'
require 'tempfile'

RSpec.describe Imports::CsvColumnMapper do
  describe '.map_headers' do
    let(:mapping) do
      {
        "ticket_number" => "Ticket Number",
        "reservation_reference" => "Reservation"
      }
    end

    it 'maps columns to internal keys' do
      row = { "Ticket Number" => "12345", "Reservation" => "XYZ" }
      result = described_class.map_headers(row, mapping)
      expect(result).to eq({
        "ticket_number" => "12345",
        "reservation_reference" => "XYZ"
      })
    end

    it 'ignores unknown columns' do
      row = { "Ticket Number" => "12345", "Unknown" => "XXX" }
      result = described_class.map_headers(row, mapping)
      expect(result).to eq({ "ticket_number" => "12345" })
    end

    it 'returns an empty hash when no headers match' do
      row = { "Other" => "value" }
      result = described_class.map_headers(row, mapping)
      expect(result).to eq({})
    end
  end

  describe '.detect_separator' do
    def create_tempfile_with_line(line)
      file = Tempfile.new('csv_test')
      file.write(line)
      file.rewind
      file
    end

    after(:each) do
      @tempfile&.close
      @tempfile&.unlink
    end

    it 'detects semicolon as separator' do
      @tempfile = create_tempfile_with_line("col1;col2;col3\n")
      expect(described_class.detect_separator(@tempfile.path)).to eq(";")
    end

    it 'detects comma as separator' do
      @tempfile = create_tempfile_with_line("col1,col2,col3\n")
      expect(described_class.detect_separator(@tempfile.path)).to eq(",")
    end

    it 'detects tab as separator' do
      @tempfile = create_tempfile_with_line("col1\tcol2\tcol3\n")
      expect(described_class.detect_separator(@tempfile.path)).to eq("\t")
    end

    it 'returns comma as default if no known separator is found' do
      @tempfile = create_tempfile_with_line("col1col2col3\n")
      expect(described_class.detect_separator(@tempfile.path)).to eq(",")
    end
  end
end
