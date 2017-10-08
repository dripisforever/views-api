class JsonWebToken
  def self.encode(payload)
    expiration = 30.minutes.from_now.to_i
    JWT.encode(payload.merge(exp: expiration), Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    begin
      HashWithIndifferentAccess.new(JWT.decode(token, Rails.application.secrets.secret_key_base).first)
    rescue
      nil
    end
  end
end
