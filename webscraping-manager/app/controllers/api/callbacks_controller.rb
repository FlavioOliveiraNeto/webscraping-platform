module Api
  class CallbacksController < ApplicationController
    def update_task
      task = ScrapingTask.find(params[:id])
      
      if params[:status] == 'completed'
        task.completed!
      elsif params[:status] == 'failed'
        task.failed!
      end

      head :ok
    rescue ActiveRecord::RecordNotFound
      head :not_found
    end
  end
end