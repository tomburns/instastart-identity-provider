class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  memoize :layer_key_id, :layer_provider_id, :layer_private_key
  helper_method :layer_key_id, :layer_provider_id, :layer_private_key

  def deployed
    render plain: 'ok'
  end

  def home
    # Renders app/views/application/home.html.erb by default
  end

  protected
  def layer_key_id
    ENV['LAYER_KEY_ID']
  end

  def layer_provider_id
    ENV['LAYER_PROVIDER_ID']
  end

  def layer_private_key
    ENV['LAYER_PRIVATE_KEY'] || File.read(ENV['LAYER_PRIVATE_KEY_PATH'])
  end
end
