require 'json/jwt'

class IdentityToken
  def initialize(user)
    @user = user
  end

  def for_nonce(nonce)
    jwt = JSON::JWT.new(claim_for_nonce(nonce))
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

  def claim_for_nonce(nonce)
    {
      iss: layer_provider_id,
      prn: @user.id.to_s,
      iat: Time.now.to_i,
      exp: default_token_expiration.to_i,
      nce: nonce,
      first_name: @user.first_name,
      last_name: @user.last_name,
      display_name: @user.display_name,
      avatar_url: @user.avatar_url
    }
  end

  def private_key
    OpenSSL::PKey::RSA.new(private_key_text)
  end

  def private_key_text
    ENV['LAYER_PRIVATE_KEY'] || File.read(ENV['LAYER_PRIVATE_KEY_PATH'])
  end
end