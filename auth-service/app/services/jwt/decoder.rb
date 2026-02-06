module Jwt
  class Decoder
    SECRET_KEY = ENV.fetch('JWT_SECRET')

    def self.call(token)
      decoded = JWT.decode(token, SECRET_KEY).first
      HashWithIndifferentAccess.new(decoded)
    rescue JWT::ExpiredSignature, JWT::DecodeError
      nil
    end
  end
end