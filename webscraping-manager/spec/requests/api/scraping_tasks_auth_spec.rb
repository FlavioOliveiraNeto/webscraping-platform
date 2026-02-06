require 'rails_helper'

RSpec.describe 'ScrapingTasks authentication', type: :request do
  let(:token) { 'invalid.jwt.token' }

  it 'returns unauthorized if token is invalid' do
    post '/api/scraping_tasks',
      headers: { 'Authorization' => "Bearer #{token}" },
      params: { source_url: 'https://example.com' }

    expect(response).to have_http_status(:unauthorized)
  end
end