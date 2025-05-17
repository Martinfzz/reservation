class ImportJob < ApplicationRecord
  enum :status, { pending: 0, processing: 1, completed: 2, failed: 3 }

  validates :status, presence: true
end
