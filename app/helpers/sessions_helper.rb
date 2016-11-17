require 'securerandom'

module SessionsHelper
  def valid_session?
    provided_token = cookies[:session_token]
    Session.exists?(token: provided_token)
  end

  def create_session_for_user(user)
    new_token = SecureRandom.urlsafe_base64
    Session.create(user_id: user.id, token: new_token)
  end

  def delete_current_session
    # Don't crash if there's a problem with the provided session_token
    token = cookies[:session_token]
    if token && session = Session.find_by(token: token)
      session.destroy
    end
  end
end