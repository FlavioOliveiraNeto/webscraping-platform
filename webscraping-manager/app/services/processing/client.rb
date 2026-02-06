module Processing
  class Client
    def self.process(task)
      url = ENV.fetch('PROCESSING_SERVICE_URL', 'http://localhost:3002')
      
      response = Faraday.post("#{url}/api/scrape") do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = { task_id: task.id, url: task.source_url }.to_json
      end

      raise "Processing Service Error: #{response.status}" unless response.success?
    end
  end
end