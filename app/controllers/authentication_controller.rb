class AuthenticationController < ApplicationController
  def identity_token
    auth_request = AuthenticationRequest.new(params[:email], params[:password])
    if auth_request.valid?
      nonce = params[:nonce]
      identity_token = IdentityToken.new(auth_request.user.id, nonce)
      render json: { identity_token: identity_token.to_s }, status: :ok
    else
      render json: { error: 'Authentication failed: verify your credentials and try again.' }, status: :unauthorized
    end
  end
end
