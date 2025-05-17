require 'rails_helper'

RSpec.describe RawImportRow, type: :model do
  it { should belong_to(:import_job) }
end
