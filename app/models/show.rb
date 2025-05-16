class Show < ApplicationRecord
  has_many :performances, dependent: :destroy

  validates :external_id, presence: true, uniqueness: true
  validates :title, presence: true
end
