class AuthenticationController < ApplicationController
  def identity_token
    auth_request = AuthenticationRequest.new(extract_params[:email], extract_params[:password])
    if auth_request.valid?
      identity_token = identity_token_generator.generate_token(auth_request.user, params[:nonce])
      render json: { identity_token: identity_token.to_s, layer_identity_token: identity_token.to_s }, status: :ok
    else
      render json: { error: 'Authentication failed: verify your credentials and try again.' }, status: :unauthorized
    end
  end

  private
  def identity_token_generator
    @identity_token_generator ||= IdentityTokenGenerator.new(layer_provider_id, layer_key_id, layer_private_key)
  end

  def extract_params
    # For backwards compatibility with older sample apps, the request params structure may be different
    email, password = params[:email], params[:password]
    if !email || !password
      user = params[:user]
      email, password = user[:email], user[:password]
    end
    { email: email, password: password }
  end
end
