module Notifications
  class Client
    def self.task_completed(task_id, vehicle)
      data = {
        brand: vehicle.brand,
        model: vehicle.model,
        price: vehicle.price,
        scraped_at: Time.current
      }
      notify('task_completed', task_id, data)
    end

    def self.task_failed(task_id, error_msg)
      notify('task_failed', task_id, { error: error_msg })
    end

    private

    def self.notify(event, task_id, data)
      url = ENV.fetch('NOTIFICATION_SERVICE_URL', 'http://localhost:3003')

      Faraday.post("#{url}/api/notifications") do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = {
          event: event,
          task_id: task_id,
          data: data
        }.to_json
      end
    rescue Faraday::Error => e
      Rails.logger.error("Failed to send notification for task #{task_id}: #{e.message}")
    end
  end
end