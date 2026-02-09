module Auth
  class Client
    BASE_URL = ENV.fetch("AUTH_SERVICE_URL", "http://localhost:3001")

    def self.login(email, password)
      response = connection.post("/api/login") do |req|
        req.headers["Content-Type"] = "application/json"
        req.body = { email: email, password: password }.to_json
      end

      if response.success?
        body = JSON.parse(response.body)
        { success: true, token: body["token"] }
      else
        body = JSON.parse(response.body) rescue {}
        { success: false, error: body["error"] || "Login failed" }
      end
    rescue Faraday::Error => e
      Rails.logger.error("Auth service error: #{e.message}")
      { success: false, error: "Authentication service unavailable" }
    end

    def self.signup(email, password, password_confirmation)
      response = connection.post("/api/signup") do |req|
        req.headers["Content-Type"] = "application/json"
        req.body = {
          user: {
            email: email,
            password: password,
            password_confirmation: password_confirmation
          }
        }.to_json
      end

      if response.success?
        { success: true }
      else
        body = JSON.parse(response.body) rescue {}
        { success: false, errors: body["errors"] || [ "Registration failed" ] }
      end
    rescue Faraday::Error => e
      Rails.logger.error("Auth service error: #{e.message}")
      { success: false, errors: [ "Authentication service unavailable" ] }
    end

    def self.connection
      Faraday.new(url: BASE_URL) do |f|
        f.options.timeout = 10
        f.options.open_timeout = 5
      end
    end
    private_class_method :connection
  end
end
