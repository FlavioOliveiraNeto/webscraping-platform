class Api::BaseController < ApplicationController
  before_action :authenticate_user!

  attr_reader :current_user

  private

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    payload = Auth::Client.decode(token)

    return unauthorized unless payload

    @current_user = payload
  end

  def unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end