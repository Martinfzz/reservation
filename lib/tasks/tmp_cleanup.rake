namespace :tmp do
  desc "Cleanup old CSV files in tmp directory"
  task cleanup_csv: :environment do
    Dir.glob(Rails.root.join("tmp", "*.csv")).each do |file|
      if File.mtime(file) < 1.day.ago
        File.delete(file)
        Rails.logger.info "Deleted temp file #{file}"
      end
    end
  end
end
