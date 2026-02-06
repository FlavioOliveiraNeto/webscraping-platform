require 'rails_helper'

RSpec.describe 'Api::Notifications', type: :request do
  describe 'POST /api/notifications' do
    let(:valid_params) do
      {
        event: 'task_completed',
        task_id: 123,
        data: { brand: 'Fiat', model: 'Uno', price: 20000 }
      }
    end

    context 'with valid parameters' do
      it 'creates a notification' do
        expect {
          post '/api/notifications', params: valid_params
        }.to change(Notification, :count).by(1)

        expect(response).to have_http_status(:created)
        
        json = JSON.parse(response.body)
        expect(json['event']).to eq('task_completed')
        expect(json['data']['brand']).to eq('Fiat')
      end
    end

    context 'with invalid parameters' do
      it 'returns error for unknown event type' do
        post '/api/notifications', params: valid_params.merge(event: 'hacker_event')
        
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error for missing data' do
        post '/api/notifications', params: { event: 'task_created' }
        
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end