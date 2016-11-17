class SessionsController < ApplicationController
  def new
    # Renders app/views/sessions/new.html.erb
  end

  include SessionsHelper
  def create
    auth_email = params[:email]
    auth_password = params[:password]
    auth_request = AuthenticationRequest.new(auth_email, auth_password)
    if auth_request.valid? && auth_request.user.admin?
      session = create_session_for_user(auth_request.user)
      response.set_cookie('session_token', session.token)
      redirect_to users_path
    else
      redirect_to login_path
    end
  end

  def destroy
    delete_current_session
    cookies.delete(:session_token)
    redirect_to root_path
  end
end