module Api
  class ScrapingController < ApplicationController
    def create
      task_id = params[:task_id]
      url = params[:url]

      if task_id.present? && url.present?
        ScrapingJob.perform_later(task_id, url)
        
        head :accepted
      else
        render json: { error: 'Missing task_id or url' }, status: :unprocessable_entity
      end
    end
  end
end