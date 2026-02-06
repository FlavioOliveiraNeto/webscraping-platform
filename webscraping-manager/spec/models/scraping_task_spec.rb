require 'rails_helper'

RSpec.describe ScrapingTask, type: :model do
  subject { build(:scraping_task) }

  describe 'validations' do
    it { should validate_presence_of(:source_url) }
    it { should validate_presence_of(:user_id) }
    
    it 'is valid with a Webmotors URL' do
      expect(subject).to be_valid
    end

    it 'is invalid with a non-Webmotors URL' do
      subject.source_url = 'https://www.google.com'
      expect(subject).not_to be_valid
      expect(subject.errors[:source_url]).to include('must be a valid Webmotors URL')
    end
  end

  describe 'enums' do
    it do
      should define_enum_for(:status)
        .with_values(
          pending: 0,
          processing: 1,
          completed: 2,
          failed: 3
        )
        .backed_by_column_of_type(:integer)
    end
  end
end