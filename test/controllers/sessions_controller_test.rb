require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { create_admin_user }

  test 'POST /sessions with an invalid login redirects to the login page' do
    post '/sessions', params: { email: 'nope@example.com', password: 'wrong_password' }
    assert_redirected_to login_path
  end

  test 'POST /sessions with a non-admin login redirects to the login page' do
    email = 'nonadmin@example.com'
    password = 'example'
    User.create(email: email, password: password)
    post '/sessions', params: { email: email, password: password }
    assert_redirected_to login_path
  end

  test 'POST /sessions with a valid login creates a session record with a token' do
    before_count = Session.count
    post '/sessions', params: base_user_params
    after_count = Session.count
    assert_equal 1, after_count - before_count
    assert_not_nil Session.last.token
  end

  test 'POST /sessions with a valid login sets a `session_token` cookie with the new session record token' do
    post '/sessions', params: base_user_params
    cookie_value = @response.cookies['session_token']
    assert_equal Session.last.token, cookie_value
  end

  test 'POST /sessions with a valid login redirects to the list of users' do
    post '/sessions', params: base_user_params
    assert_redirected_to users_path
  end

  private
  def create_admin_user
    User.create(admin_user_params)
  end
end