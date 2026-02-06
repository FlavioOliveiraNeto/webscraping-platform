require 'rails_helper'

RSpec.describe "Api::Scraping", type: :request do
  describe "POST /api/scrape" do
    let(:valid_params) { { task_id: 1, url: 'https://webmotors.com.br/teste' } }

    it "enqueues the scraping job and returns accepted" do
      expect {
        post "/api/scrape", params: valid_params
      }.to have_enqueued_job(ScrapingJob).with('1', 'https://webmotors.com.br/teste')

      expect(response).to have_http_status(:accepted)
    end

    it "returns error when params are missing" do
      post "/api/scrape", params: { task_id: 1 }
      
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end