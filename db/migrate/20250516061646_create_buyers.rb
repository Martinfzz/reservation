class CreateBuyers < ActiveRecord::Migration[8.0]
  def change
    create_table :buyers do |t|
      t.string :last_name
      t.string :first_name
      t.string :email
      t.string :address
      t.integer :postal_code
      t.string :country
      t.integer :age
      t.string :gender

      t.timestamps
    end

    add_index :buyers, :email, unique: true
  end
end
