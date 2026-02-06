module Jwt
  class Encoder
    SECRET_KEY = ENV.fetch('JWT_SECRET')
    EXPIRATION = 24.hours.from_now.to_i

    def self.call(payload)
      payload[:exp] = EXPIRATION
      JWT.encode(payload, SECRET_KEY)
    end
  end
end