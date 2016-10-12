class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def deployed
    render text: 'ok'
  end

  def home
    @key_id_set = !ENV['LAYER_KEY_ID'].blank?
    @provider_id_set = !ENV['LAYER_PROVIDER_ID'].blank?
    @private_key_set = !ENV['LAYER_PRIVATE_KEY'].blank?
    # Renders app/views/application/home.html.erb by default
  end
end
