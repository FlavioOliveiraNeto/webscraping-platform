require 'rails_helper'

RSpec.describe ScrapedVehicle, type: :model do
  subject { build(:scraped_vehicle) }

  describe 'validations' do
    it { should validate_presence_of(:task_id) }
    it { should validate_presence_of(:brand) }
    it { should validate_presence_of(:model) }
    it { should validate_presence_of(:price) }
  end
end