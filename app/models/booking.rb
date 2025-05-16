class Booking < ApplicationRecord
  belongs_to :buyer
  belongs_to :performance

  validates :ticket_number, :reservation_reference, presence: true, uniqueness: true
  validates :reservation_date, :reservation_time, :price, :product_type, :sales_channel, presence: true
end
