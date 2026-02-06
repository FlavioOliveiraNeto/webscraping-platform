require 'rails_helper'

RSpec.describe EnqueueScrapingJob, type: :job do
  let(:task) { create(:scraping_task, status: :pending) }

  before do
    allow(Processing::Client).to receive(:process)
    allow(Notifications::Client).to receive(:task_failed)
  end

  it 'processes the task successfully' do
    described_class.perform_now(task.id)

    task.reload

    expect(task.status).to eq('processing')
    expect(Processing::Client).to have_received(:process).with(task)
  end

  context 'when processing fails' do
    before do
      allow(Processing::Client).to receive(:process).and_raise(StandardError.new("Service down"))
    end

    it 'updates status to failed and notifies' do
      described_class.perform_now(task.id)

      task.reload
      expect(task).to be_failed
      expect(Notifications::Client).to have_received(:task_failed).with(task, "Service down")
    end
  end
end