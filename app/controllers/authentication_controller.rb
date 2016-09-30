class AuthenticationController < ApplicationController
  def identity_token
    requested_email = params[:email]
    requested_password = params[:password]
    auth_request = AuthenticationRequest.new(requested_email, requested_password)
    if auth_request.valid?
      nonce = params[:nonce]
      token_string = IdentityToken.new(auth_request.user).for_nonce(nonce)
      render json: { identity_token: token_string }, status: :ok
    else
      render json: { identity_token: '' }, status: :unauthorized
    end
  end
end