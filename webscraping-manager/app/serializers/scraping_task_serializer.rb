class ScrapingTaskSerializer
  def initialize(task)
    @task = task
  end

  def as_json(_options = {})
    {
      id: @task.id,
      source_url: @task.source_url,
      status: @task.status,
      created_at: @task.created_at
    }
  end
end