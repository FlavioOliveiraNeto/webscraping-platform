module Manager
  class Client
    BASE_URL = ENV.fetch("MANAGER_SERVICE_URL", "http://localhost:3000")

    def self.list_tasks(token)
      response = connection.get("/api/scraping_tasks") do |req|
        req.headers["Authorization"] = "Bearer #{token}"
      end

      if response.success?
        tasks = JSON.parse(response.body)
        { success: true, tasks: tasks }
      else
        error_body(response)
      end
    rescue Faraday::Error => e
      Rails.logger.error("Manager service error: #{e.message}")
      { success: false, error: "Manager service unavailable" }
    end

    def self.create_task(token, source_url)
      response = connection.post("/api/scraping_tasks") do |req|
        req.headers["Authorization"] = "Bearer #{token}"
        req.headers["Content-Type"] = "application/json"
        req.body = { source_url: source_url }.to_json
      end

      if response.success?
        task = JSON.parse(response.body)
        { success: true, task: task.with_indifferent_access }
      else
        error_body(response)
      end
    rescue Faraday::Error => e
      Rails.logger.error("Manager service error: #{e.message}")
      { success: false, error: "Manager service unavailable" }
    end

    def self.show_task(token, id)
      response = connection.get("/api/scraping_tasks/#{id}") do |req|
        req.headers["Authorization"] = "Bearer #{token}"
      end

      if response.success?
        task = JSON.parse(response.body)
        { success: true, task: task.with_indifferent_access }
      else
        error_body(response)
      end
    rescue Faraday::Error => e
      Rails.logger.error("Manager service error: #{e.message}")
      { success: false, error: "Manager service unavailable" }
    end

    def self.connection
      Faraday.new(url: BASE_URL) do |f|
        f.options.timeout = 15
        f.options.open_timeout = 5
      end
    end
    private_class_method :connection

    def self.error_body(response)
      body = JSON.parse(response.body) rescue {}
      {
        success: false,
        status: response.status,
        error: body["error"],
        errors: body["errors"]
      }
    end
    private_class_method :error_body
  end
end
