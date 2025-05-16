class Performance < ApplicationRecord
  belongs_to :show
  has_many :bookings, dependent: :destroy

  validates :external_id, presence: true, uniqueness: true
  validates :title, presence: true
  validates :start_date, :start_time, presence: true
  validates :end_date, :end_time, presence: true
end
