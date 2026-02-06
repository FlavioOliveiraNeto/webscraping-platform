require 'rails_helper'

RSpec.describe Notification, type: :model do
  subject { build(:notification) }

  describe 'validations' do
    it { should validate_presence_of(:event_type) }
    it { should validate_presence_of(:task_id) }
    it { should validate_presence_of(:payload) }

    it 'allows valid event types' do
      %w[task_created task_completed task_failed].each do |type|
        subject.event_type = type
        expect(subject).to be_valid
      end
    end

    it 'rejects invalid event types' do
      subject.event_type = 'user_logged_in'
      expect(subject).not_to be_valid
    end
  end
end