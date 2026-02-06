class EnqueueScrapingJob < ApplicationJob
  queue_as :default

  def perform(task_id)
    task = ScrapingTask.find(task_id)
    task.processing!

    Processing::Client.process(task)

  rescue StandardError => e
    task.failed!
    Notifications::Client.task_failed(task, e.message)
  end
end
