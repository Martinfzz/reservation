class CreateImportJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :import_jobs do |t|
      t.integer :status, default: 0, null: false
      t.integer :processed_rows
      t.integer :total_rows
      t.text :error_log

      t.timestamps
    end
  end
end
