require 'rails_helper'

RSpec.describe ImportsController, type: :request do
  describe 'GET /imports/new' do
    it 'renders the new template' do
      get new_import_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("form")
    end
  end

  describe 'POST /imports/preview' do
    context 'when no file is uploaded' do
      it 'redirects to new import page with alert' do
        post preview_imports_path, params: {}

        expect(response).to redirect_to(new_import_path)
        follow_redirect!

        expect(response.body).to include(I18n.t("imports.missing_file"))
      end
    end

    context 'when a valid file is uploaded' do
      let(:csv_content) { "Email;Nom\njohn@example.com;Doe" }

      it 'renders the preview partial with headers' do
        file = Tempfile.new([ 'test', '.csv' ])
        file.write(csv_content)
        file.rewind

        uploaded = Rack::Test::UploadedFile.new(file.path, 'text/csv')

        post preview_imports_path, params: { csv_file: uploaded }

        expect(response.body).to include("csv_preview")
        expect(response.body).to include("Email")
        expect(response.body).to include("Nom")

        file.close
        file.unlink
      end
    end
  end

  describe 'POST /imports/import' do
    let(:file_path) { Rails.root.join('tmp', 'dummy.csv').to_s }
    let(:mapping) do
      Imports::CsvColumnMapper::EXPECTED_COLUMNS.keys.index_with { |key| key.to_s.upcase }
    end

    before do
      File.write(file_path, "data")
      allow(LoadCsvJob).to receive(:perform_async)
    end

    after do
      FileUtils.rm_f(file_path)
    end

    context 'with complete mapping' do
      it 'creates a job and enqueues LoadCsvJob' do
        expect {
          post import_imports_path, params: {
            file_path: file_path,
            mapping: mapping
          }
        }.to change { ImportJob.count }.by(1)

        expect(response).to redirect_to(new_import_path)
        expect(flash[:notice]).to eq(I18n.t("imports.import_started"))
        expect(LoadCsvJob).to have_received(:perform_async).with(file_path, ImportJob.last.id, mapping)
      end
    end

    context 'with incomplete mapping' do
      it 'redirects with alert' do
        mapping["email"] = ""

        post import_imports_path, params: {
          file_path: file_path,
          mapping: mapping
        }

        expect(response).to redirect_to(new_import_path)
        expect(flash[:alert]).to eq(I18n.t("imports.missing_fields"))
      end
    end
  end
end
