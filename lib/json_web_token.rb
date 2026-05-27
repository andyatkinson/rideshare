class JsonWebToken
  SECRET_KEY = ENV.fetch("JWT_SECRET") do
    Rails.application.credentials.secret_key_base.to_s
  end

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, "HS256")
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  end
end
