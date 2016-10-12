class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def deployed
    render text: 'ok'
  end

  def home
    render text: 'home'
  end
end
