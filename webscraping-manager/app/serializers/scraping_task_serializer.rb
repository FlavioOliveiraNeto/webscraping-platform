class ScrapingTaskSerializer
  def initialize(task)
    @task = task
  end

  def as_json(_options = {})
    data = {
      id: @task.id,
      source_url: @task.source_url,
      status: @task.status,
      created_at: @task.created_at,
      brand: @task.brand,
      model: @task.model,
      price: @task.price,
      error_message: @task.error_message
    }
    data
  end
end