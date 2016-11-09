class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_filter :set_cors_preflight_headers
  after_filter :set_cors_access_control_headers

  def deployed
    render plain: 'ok'
  end

  def home
    @key_id_set = !ENV['LAYER_KEY_ID'].blank?
    @provider_id_set = !ENV['LAYER_PROVIDER_ID'].blank?
    @private_key_set = !ENV['LAYER_PRIVATE_KEY'].blank?
    # Renders app/views/application/home.html.erb by default
  end

  def set_cors_preflight_headers
    if request.method == :options
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Request-Method'] = '*'
      headers['Access-Control-Allow-Headers'] = '*'
      render plain: ''
    end
  end

  def set_cors_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = '*'
  end
end
