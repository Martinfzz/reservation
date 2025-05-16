class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.integer :ticket_number
      t.integer :reservation_reference
      t.date :reservation_date
      t.time :reservation_time
      t.decimal :price
      t.string :product_type
      t.string :sales_channel
      t.references :buyer, null: false, foreign_key: true
      t.references :performance, null: false, foreign_key: true

      t.timestamps
    end

    add_index :bookings, :ticket_number, unique: true
    add_index :bookings, :reservation_reference, unique: true
  end
end
