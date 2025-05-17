class CreateRawImportRows < ActiveRecord::Migration[8.0]
  def change
    create_table :raw_import_rows do |t|
      t.references :import_job, null: false, foreign_key: true
      t.jsonb :data, null: false, default: {}
      t.timestamps
    end
  end
end
