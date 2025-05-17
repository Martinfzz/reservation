class Booking < ApplicationRecord
  belongs_to :buyer
  belongs_to :performance

  validates :ticket_number, presence: true, uniqueness: true
  validates :reservation_reference, :reservation_date, :reservation_time, :price, :product_type, :sales_channel, presence: true
end
