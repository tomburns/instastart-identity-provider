class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  helper_method :layer_key_id, :layer_provider_id, :layer_private_key

  def deployed
    render plain: 'ok'
  end

  include SessionsHelper
  def home
    @valid_session = valid_session?
    # Renders app/views/application/home.html.erb by default
  end

  protected
  def layer_key_id
    @@layer_key_id ||= ENV['LAYER_KEY_ID']
  end

  def layer_provider_id
    @@layer_provider_id ||= ENV['LAYER_PROVIDER_ID']
  end

  def layer_private_key
    @@layer_private_key ||= (ENV['LAYER_PRIVATE_KEY'] || (keypath = ENV['LAYER_PRIVATE_KEY_PATH'] && File.read(keypath)))
  end
end
