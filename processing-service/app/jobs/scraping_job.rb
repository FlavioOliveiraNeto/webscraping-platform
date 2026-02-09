class ScrapingJob < ApplicationJob
  queue_as :default

  def perform(task_id, url)
    Rails.logger.info("Starting scraping for Task #{task_id}")

    result = Scraper::Webmotors.call(url)

    vehicle = ScrapedVehicle.create!(
      task_id: task_id,
      brand: result[:brand],
      model: result[:model],
      price: result[:price]
    )

    Notifications::Client.task_completed(task_id, vehicle)

    Manager::Client.update_status(task_id, 'completed',
      brand: result[:brand],
      model: result[:model],
      price: result[:price]
    )

  rescue => e
    Rails.logger.error("Scraping failed: #{e.message}")
    Notifications::Client.task_failed(task_id, e.message)
    Manager::Client.update_status(task_id, 'failed', error_message: e.message)
  end
end