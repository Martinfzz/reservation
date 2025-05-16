require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe 'associations' do
    it { should belong_to(:buyer) }
    it { should belong_to(:performance) }
  end

  describe 'validations' do
    subject { FactoryBot.create(:booking) }

    it { should validate_presence_of(:ticket_number) }
    it { should validate_uniqueness_of(:ticket_number) }

    it { should validate_presence_of(:reservation_reference) }
    it { should validate_uniqueness_of(:reservation_reference) }

    it { should validate_presence_of(:reservation_date) }
    it { should validate_presence_of(:reservation_time) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:product_type) }
    it { should validate_presence_of(:sales_channel) }
  end
end
