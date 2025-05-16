require 'rails_helper'

RSpec.describe Performance, type: :model do
  describe 'associations' do
    it { should belong_to(:show) }
    it { should have_many(:bookings).dependent(:destroy) }
  end

  describe 'validations' do
    subject { FactoryBot.create(:performance) }

    it { should validate_presence_of(:external_id) }
    it { should validate_uniqueness_of(:external_id) }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_date) }
    it { should validate_presence_of(:end_time) }
  end
end
