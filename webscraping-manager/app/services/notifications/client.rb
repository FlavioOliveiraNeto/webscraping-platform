module Notifications
  class Client
    def self.task_created(task)
      data = {
        source_url: task.source_url,
        created_at: task.created_at
      }
      notify('task_created', task, data)
    end

    def self.task_failed(task, error_msg)
      notify('task_failed', task, error: error_msg)
    end

    private

    def self.notify(event, task, extra = {})
      url = ENV.fetch('NOTIFICATION_SERVICE_URL', 'http://localhost:3003')

      Faraday.post("#{url}/api/notifications") do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = {
          event: event,
          task_id: task.id,
          user_id: task.user_id,
          data: extra
        }.to_json
      end
    rescue Faraday::Error => e
      Rails.logger.error("Failed to send notification: #{e.message}")
    end
  end
end