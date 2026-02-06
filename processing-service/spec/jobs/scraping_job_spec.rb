require 'rails_helper'

RSpec.describe ScrapingJob, type: :job do
  let(:task_id) { 123 }
  let(:url) { 'https://www.webmotors.com.br/teste' }
  
  let(:scraped_data) { { brand: 'Toyota', model: 'Corolla', price: '100000' } }

  before do
    allow(Scraper::Webmotors).to receive(:call).with(url).and_return(scraped_data)
    allow(Notifications::Client).to receive(:task_completed)
    allow(Notifications::Client).to receive(:task_failed)
  end

  describe '#perform' do
    it 'scrapes, saves and notifies success' do
      expect {
        described_class.perform_now(task_id, url)
      }.to change(ScrapedVehicle, :count).by(1)

      vehicle = ScrapedVehicle.last
      expect(vehicle.brand).to eq('Toyota')
      expect(vehicle.task_id).to eq(task_id)

      expect(Notifications::Client).to have_received(:task_completed).with(task_id, vehicle)
    end

    context 'when scraping fails' do
      before do
        allow(Scraper::Webmotors).to receive(:call).and_raise(StandardError.new("HTML mudou"))
      end

      it 'catches the error and notifies failure' do
        expect {
          described_class.perform_now(task_id, url)
        }.not_to change(ScrapedVehicle, :count)

        expect(Notifications::Client).to have_received(:task_failed).with(task_id, "HTML mudou")
      end
    end
  end
end