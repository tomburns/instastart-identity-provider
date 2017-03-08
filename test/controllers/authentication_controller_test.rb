require 'test_helper'
require 'json'

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  test 'POST /authenticate renders an identity token when provided with valid credentials' do
    User.create(base_user_params)
    post "/authenticate", params: { email: base_user_params[:email], password: base_user_params[:password], nonce: 'test_nonce' }
    assert_response :success
    assert_not_nil JSON.parse(@response.body)['identity_token']
  end

  test 'POST /authenticate works when credentials are nested inside :user in request params' do
    User.create(base_user_params)
    post "/authenticate", params: { user: { email: base_user_params[:email], password: base_user_params[:password]}, nonce: 'test_nonce' }
    assert_response :success
    assert_not_nil JSON.parse(@response.body)['identity_token']
  end

  test 'POST /authenticate renders an error when provided with invalid credentials' do
    User.create(base_user_params)
    post "/authenticate", params: { email: base_user_params[:email], password: 'wrong_password', nonce: 'test_nonce' }
    assert_response :unauthorized
    response_body = JSON.parse(@response.body)
    assert_not_nil response_body['error']
    assert_equal "Authentication failed: verify your credentials and try again.", response_body['error']
  end
end