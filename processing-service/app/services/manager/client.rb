module Manager
  class Client
    def self.update_status(task_id, status, data = {})
      url = ENV.fetch('WEBSCRAPING_MANAGER_URL', 'http://webscraping-manager:3000')

      Faraday.post("#{url}/api/callbacks/tasks/#{task_id}") do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = { status: status }.merge(data).to_json
      end
    rescue Faraday::Error => e
      Rails.logger.error "Failed to update Manager task status: #{e.message}"
    end
  end
end