require 'json/jwt'

class IdentityToken
  attr_reader :user_id, :nonce

  def initialize(user_id, nonce)
    @user_id = user_id
    @nonce = nonce
  end

  def to_s
    jwt = JSON::JWT.new(claim)
    jwt.header['typ'] = 'JWT'
    jwt.header['cty'] = 'layer-eit;v=1'
    jwt.header['kid'] = layer_key_id
    jwt.sign(private_key, :RS256).to_s
  end

  private
  def default_token_expiration
    24.hours.from_now
  end

  def layer_provider_id
    ENV['LAYER_PROVIDER_ID']
  end

  def layer_key_id
    ENV['LAYER_KEY_ID']
  end

  def claim
    {
      iss: layer_provider_id,
      prn: user_id.to_s,
      iat: Time.now.to_i,
      exp: default_token_expiration.to_i,
      nce: nonce
    }
  end

  def private_key
    OpenSSL::PKey::RSA.new(private_key_text)
  end

  def private_key_text
    ENV['LAYER_PRIVATE_KEY'] || File.read(ENV['LAYER_PRIVATE_KEY_PATH'])
  end
end
