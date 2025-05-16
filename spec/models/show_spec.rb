require 'rails_helper'

RSpec.describe Show, type: :model do
  describe 'associations' do
    it { should have_many(:performances).dependent(:destroy) }
  end

  describe 'validations' do
    subject { FactoryBot.create(:show) }

    it { should validate_presence_of(:external_id) }
    it { should validate_uniqueness_of(:external_id) }

    it { should validate_presence_of(:title) }
  end
end
