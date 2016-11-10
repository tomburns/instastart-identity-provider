require 'json/jwt'

class IdentityTokenGenerator
  attr_reader :provider_id, :key_id, :private_key
  attr_accessor :lifetime

  def initialize(provider_id, key_id, private_key)
    @provider_id = provider_id
    @key_id = key_id
    @private_key = OpenSSL::PKey::RSA.new(private_key)
  end

  def generate_token(user_id, nonce, expires_at = 24.hours.from_now)
    claim = identity_claim(user_id, nonce, expires_at)
    jwt = JSON::JWT.new(claim)
    jwt.header['typ'] = 'JWT'
    jwt.header['cty'] = 'layer-eit;v=1'
    jwt.header['kid'] = key_id
    jwt.sign(private_key, :RS256).to_s
  end

  private
  def identity_claim(user_id, nonce, expires_at)
    {
      iss: provider_id,
      prn: user_id.to_s,
      iat: Time.now.to_i,
      exp: expires_at.to_i,
      nce: nonce
    }
  end
end
