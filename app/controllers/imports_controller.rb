class ImportsController < ApplicationController
  require "csv"

  PERMITTED_MAPPING_PARAMS = Imports::CsvColumnMapper::EXPECTED_COLUMNS.keys

  def new; end

  def preview
    if params[:csv_file].blank?
      redirect_to new_import_path, alert: t("imports.missing_file")
      return
    end

    headers = extract_csv_headers(params[:csv_file].tempfile)

    tmp_path = copy_to_tmp(params[:csv_file].tempfile)

    render turbo_stream: turbo_stream.replace(
      "csv_preview",
      partial: "imports/preview",
      locals: {
        csv_headers: headers,
        expected_columns: Imports::CsvColumnMapper::EXPECTED_COLUMNS,
        tempfile_path: tmp_path
      }
    )
  end

  def import
    mapping = permitted_mapping
    filepath = params[:file_path]

    if mapping.values.any?(&:blank?)
      redirect_to new_import_path, alert: t("imports.missing_fields")
      return
    end

    job = ImportJob.create!(status: :pending, total_rows: 0, processed_rows: 0)
    LoadCsvJob.perform_async(filepath, job.id, mapping)

    redirect_to new_import_path, notice: t("imports.import_started")
  end

  private

  def extract_csv_headers(file)
    CSV.open(file, col_sep: Imports::CsvColumnMapper.detect_separator(file), headers: true).first&.headers || []
  end

  def copy_to_tmp(file)
    tmp_path = Rails.root.join("tmp", "#{SecureRandom.hex}.csv")
    FileUtils.cp(file.path, tmp_path)
    tmp_path
  end

  def permitted_mapping
    raw = params.require(:mapping).permit(PERMITTED_MAPPING_PARAMS)
    JSON.parse(raw.to_json)
  end
end
