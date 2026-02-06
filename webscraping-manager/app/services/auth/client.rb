require 'jwt'

module Auth
  class Client
    SECRET_KEY = ENV.fetch('JWT_SECRET')

    def self.decode(token)
      return nil unless token

      decoded = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256').first
      HashWithIndifferentAccess.new(decoded)
    rescue JWT::DecodeError, JWT::ExpiredSignature
      nil
    end
  end
end