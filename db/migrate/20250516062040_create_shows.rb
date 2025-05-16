class CreateShows < ActiveRecord::Migration[8.0]
  def change
    create_table :shows do |t|
      t.integer :external_id
      t.string :title

      t.timestamps
    end

    add_index :shows, :external_id, unique: true
  end
end
