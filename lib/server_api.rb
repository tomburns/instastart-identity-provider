require 'net/http'
require 'uri'
require 'json'
require 'httparty'

class ServerAPI
  HOST = 'https://api.layer.com'
  attr_reader :app_id, :token

  def initialize(app_id = ENV['LAYER_APP_ID'], token = ENV['LAYER_SERVER_API_TOKEN'])
    @app_id = app_id
    @token = token
  end

  def create_identity(user_id, params)
    # params is a hash with keys corresponding to Layer Identity fields:
    # https://docs.layer.com/reference/server_api/identities.out#create-identity
    HTTParty.post("#{HOST}/apps/#{app_uuid}/users/#{user_id}/identity",
      body: params.to_json,
      headers: {
        'Accept' => 'application/vnd.layer+json; version=2.0',
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{token}"
      }
    )
  end

  def follow_users(originator_user_id, target_user_ids)
    # https://docs.layer.com/reference/client_api/identities.out#follow-multiple-users
    # Using Client API proxy: https://docs.layer.com/reference/server_api/clientapiproxy
    HTTParty.post("#{HOST}/apps/#{app_uuid}/users/#{originator_user_id}/following/users",
      body: target_user_ids.to_json,
      headers: {
        'Accept' => 'application/vnd.layer+json; version=2.0',
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{token}"
      }
    )
  end

  private
  def app_uuid
    app_id.split('/').last
  end
end