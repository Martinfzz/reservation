class ChangeIndexOnReservationReferenceInBookings < ActiveRecord::Migration[8.0]
  def change
    remove_index :bookings, :reservation_reference
    add_index :bookings, :reservation_reference
  end
end
