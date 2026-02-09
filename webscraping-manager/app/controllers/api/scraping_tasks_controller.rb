module Api
  class ScrapingTasksController < BaseController
    def index
      tasks = ScrapingTask.where(user_id: current_user['user_id']).order(created_at: :desc)
      render json: tasks.map { |t| ScrapingTaskSerializer.new(t).as_json }
    end

    def create
      task = ScrapingTask.new(
        source_url: params[:source_url],
        title: params[:title],             
        description: params[:description], 
        status: :pending,
        user_id: current_user['user_id']
      )

      if task.save
        EnqueueScrapingJob.perform_later(task.id)
        Notifications::Client.task_created(task)
        render json: ScrapingTaskSerializer.new(task).as_json, status: :created
      else
        render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def show
      task = ScrapingTask.find_by(id: params[:id], user_id: current_user['user_id'])
      
      if task
        render json: ScrapingTaskSerializer.new(task).as_json
      else
        render json: { error: 'Task not found' }, status: :not_found
      end
    end
  end
end