require 'rails_helper'

RSpec.describe ImportJob, type: :model do
  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, processing: 1, completed: 2, failed: 3) }
  end

  describe 'validations' do
    it { should validate_presence_of(:status) }
  end

  describe 'default values' do
    it 'sets the default status to pending' do
      import_job = ImportJob.new
      expect(import_job.status).to eq('pending')
    end
  end
end
