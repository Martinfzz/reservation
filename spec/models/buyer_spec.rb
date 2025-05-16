require 'rails_helper'

RSpec.describe Buyer, type: :model do
  describe 'associations' do
    it { should have_many(:bookings).dependent(:destroy) }
  end

  describe 'validations' do
    subject { FactoryBot.create(:buyer) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end
end
