module Api
  class NotificationsController < ApplicationController
    def index
      render json: Notification.order(created_at: :desc)
    end
    
    def create
      notification = Notification.new(
        event_type: params[:event],
        task_id: params[:task_id],
        payload: params[:data]
      )

      if notification.save
        render json: NotificationSerializer.new(notification).as_json, status: :created
      else
        Rails.logger.error("Notification errors: #{notification.errors.full_messages}")
        render json: { errors: notification.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActionController::ParameterMissing
      render json: { error: 'Invalid parameters' }, status: :bad_request
    end
  end
end