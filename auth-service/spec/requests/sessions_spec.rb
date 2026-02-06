require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let!(:user) { create(:user, email: 'teste@auth.com', password: 'password123') }

  describe 'POST /api/login' do
    context 'with valid credentials' do
      it 'returns a JWT token' do
        post '/api/login', params: { email: 'teste@auth.com', password: 'password123' }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json).to have_key('token')
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized' do
        post '/api/login', params: { email: 'teste@auth.com', password: 'wrongpassword' }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end