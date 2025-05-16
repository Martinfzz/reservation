class Buyer < ApplicationRecord
  has_many :bookings, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :last_name, :first_name, presence: true
end
