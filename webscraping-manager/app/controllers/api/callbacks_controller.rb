module Api
  class CallbacksController < ApplicationController
    def update_task
      task = ScrapingTask.find(params[:id])

      if params[:status] == 'completed'
        task.update!(
          status: :completed,
          brand: params[:brand],
          model: params[:model],
          price: params[:price]
        )
      elsif params[:status] == 'failed'
        task.update!(
          status: :failed,
          error_message: params[:error_message]
        )
      end

      head :ok
    rescue ActiveRecord::RecordNotFound
      head :not_found
    end
  end
end