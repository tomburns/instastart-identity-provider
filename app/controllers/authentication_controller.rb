class AuthenticationController < ApplicationController
  def identity_token
    auth_request = AuthenticationRequest.new(params[:email], params[:password])
    if auth_request.valid?
      identity_token = identity_token_generator.generate_token(auth_request.user.id, params[:nonce])
      render json: { identity_token: identity_token.to_s }, status: :ok
    else
      render json: { error: 'Authentication failed: verify your credentials and try again.' }, status: :unauthorized
    end
  end

  private
  def identity_token_generator
    IdentityTokenGenerator.new(layer_provider_id, layer_key_id, layer_private_key)
  end
end
