class CreatePerformances < ActiveRecord::Migration[8.0]
  def change
    create_table :performances do |t|
      t.integer :external_id
      t.references :show, null: false, foreign_key: true
      t.string :title
      t.date :start_date
      t.time :start_time
      t.date :end_date
      t.time :end_time

      t.timestamps
    end

    add_index :performances, :external_id, unique: true
  end
end
