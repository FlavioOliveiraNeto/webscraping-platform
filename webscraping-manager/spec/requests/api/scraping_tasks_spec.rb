require 'rails_helper'

RSpec.describe 'Api::ScrapingTasks', type: :request do
  let(:user_id) { 10 }
  let(:valid_token) { 'valid.jwt.token' }
  let(:auth_payload) { { 'user_id' => user_id, 'email' => 'teste@teste.com' } }

  before do
    allow(Auth::Client).to receive(:decode).with(valid_token).and_return(auth_payload)
    allow(Auth::Client).to receive(:decode).with('invalid.token').and_return(nil)
    
    allow(Notifications::Client).to receive(:task_created)
  end

  describe 'POST /api/scraping_tasks' do
    context 'when authorized' do
      let(:headers) { { 'Authorization' => "Bearer #{valid_token}" } }
      let(:valid_params) { { source_url: 'https://www.webmotors.com.br/comprar/carro' } }

      it 'creates a task and enqueues a job' do
        expect {
          post '/api/scraping_tasks', params: valid_params, headers: headers
        }.to change(ScrapingTask, :count).by(1)
        .and have_enqueued_job(EnqueueScrapingJob)

        expect(response).to have_http_status(:created)
      end

      it 'calls the notification client' do
        post '/api/scraping_tasks', params: valid_params, headers: headers
        
        task = ScrapingTask.last
        expect(Notifications::Client).to have_received(:task_created).with(task)
      end

      it 'returns error for invalid URL' do
        post '/api/scraping_tasks', params: { source_url: 'google.com' }, headers: headers
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include('Source url must be a valid Webmotors URL')
      end
    end

    context 'when unauthorized' do
      it 'returns 401' do
        post '/api/scraping_tasks', headers: { 'Authorization' => 'Bearer invalid.token' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/scraping_tasks' do
    let(:headers) { { 'Authorization' => "Bearer #{valid_token}" } }

    it 'returns only tasks belonging to the user' do
      create(:scraping_task, user_id: user_id)
      create(:scraping_task, user_id: 999)

      get '/api/scraping_tasks', headers: headers

      json = JSON.parse(response.body)
      expect(json.size).to eq(1)
      expect(json.first['id']).to eq(ScrapingTask.find_by(user_id: user_id).id)
    end
  end
end