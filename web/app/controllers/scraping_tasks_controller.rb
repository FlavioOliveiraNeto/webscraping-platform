class ScrapingTasksController < ApplicationController
  before_action :require_authentication

  def index
    result = Manager::Client.list_tasks(current_token)

    if result[:success]
      @tasks = result[:tasks]
    else
      handle_api_error(result)
      @tasks = []
    end
  end

  def new
  end

  def create
    result = Manager::Client.create_task(current_token, params[:source_url], params[:title], params[:description])

    if result[:success]
      flash[:notice] = "Tarefa de scraping criada com sucesso."
      redirect_to scraping_task_path(result[:task][:id])
    else
      flash.now[:alert] = result[:errors]&.join(", ") || result[:error] || "Falha ao criar tarefa."
      render :new, status: :unprocessable_entity
    end
  end

  def show
    result = Manager::Client.show_task(current_token, params[:id])

    if result[:success]
      @task = result[:task]
    else
      handle_api_error(result)
      redirect_to scraping_tasks_path unless performed?
    end
  end

  private

  def handle_api_error(result)
    if result[:status] == 401
      session.delete(:jwt_token)
      flash[:alert] = "Sessao expirada. Faca login novamente."
      redirect_to login_path
    else
      flash[:alert] = result[:error] || "Ocorreu um erro."
    end
  end
end
