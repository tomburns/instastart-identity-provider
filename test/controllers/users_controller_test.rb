require 'test_helper'

class UsersControllerUnauthenticatedTest < ActionDispatch::IntegrationTest
  # App currently does not have an admin user registered
  test 'GET /users redirects to new user page' do
    get '/users'
    assert_redirected_to new_user_path
  end

  test 'GET /users/:id redirects to new user page' do
    arbitrary_user_id = 1
    get user_path(arbitrary_user_id)
    assert_redirected_to new_user_path
  end

  test 'POST /users creates an admin user if there currently is no admin user' do
    post '/users', { params: { user: base_user_params }, headers: @auth_header }
    assert User.last.admin?
  end

  test 'GET /users/:id/edit redirects to new user page' do
    arbitrary_user_id = 1
    get edit_user_path(arbitrary_user_id)
    assert_redirected_to new_user_path
  end

  test 'PATCH /users/:id redirects to new user page' do
    arbitrary_user_id = 1
    arbitrary_update_params = { user: { email: 'new_email@example.com' } }
    patch user_path(arbitrary_user_id), params: arbitrary_update_params
    assert_redirected_to new_user_path
  end
end

class UsersControllerUnauthenticatedWithExistingAdminTest < ActionDispatch::IntegrationTest
  # App currently does have an admin user registered
  setup do
    User.create(admin_user_params)
  end

  test 'GET /users redirects to login page' do
    get '/users'
    assert_redirected_to login_path
  end

  test 'GET /users/:id redirects to login page' do
    arbitrary_user_id = 1
    get user_path(arbitrary_user_id)
    assert_redirected_to login_path
  end

  test 'POST /users redirects to login page' do
    post '/users', params: { user: base_user_params }
    assert_redirected_to login_path
  end

  test 'GET /users/:id/edit redirects to login page' do
    arbitrary_user_id = 1
    get edit_user_path(arbitrary_user_id)
    assert_redirected_to login_path
  end

  test 'PATCH /users/:id redirects to login page' do
    arbitrary_user_id = 1
    arbitrary_update_params = { user: { email: 'new_email@example.com' } }
    patch user_path(arbitrary_user_id), params: arbitrary_update_params
    assert_redirected_to login_path
  end
end

class UsersControllerAuthenticatedTest < ActionDispatch::IntegrationTest
  setup do
    token = authenticated_session.token
    @auth_header = { 'HTTP_COOKIE' => "session_token=#{token};" }
  end

  test 'GET /users renders users#index' do
    get '/users', headers: @auth_header
    assert_template :index
  end

  test 'GET /users/:id renders users#show' do
    u = User.create(base_user_params)
    get user_path(u), headers: @auth_header
    assert_template :show
  end

  test 'POST /users creates a new user record with the provided parameters' do
    before_count = User.count
    post '/users', { params: { user: base_user_params }, headers: @auth_header }
    after_count = User.count
    assert_equal (before_count + 1), after_count
    assert_equal base_user_params[:email], User.last.email
  end

  test 'POST /users creates a non-admin user if an admin exists and the user is created as a non-admin' do
    admin_user = User.create(admin_user_params)
    new_user_params = base_user_params.merge(email: 'other@example.com', is_admin: false)
    post '/users', { params: { user: new_user_params }, headers: @auth_header }
    assert_not User.find_by_email('other@example.com').admin?
  end

  test 'POST /users creates an admin if requested' do
    post '/users', { params: { user: admin_user_params }, headers: @auth_header }
    assert User.last.admin?
  end

  test 'POST /users redirects to newly created user' do
    post '/users', { params: { user: base_user_params }, headers: @auth_header}
    assert_redirected_to user_path(User.last)
  end

  test 'GET /users/:id/edit renders users#edit' do
    u = User.create(base_user_params)
    get edit_user_path(u), { headers: @auth_header }
    assert_template :edit
  end

  test 'PATCH /users/:id updates the referenced user record with the provided parameters' do
    u = User.create(base_user_params)
    patch user_path(u), { params: { user: { email: 'new@email.com' } }, headers: @auth_header }
    assert_equal 'new@email.com', u.reload.email
  end

  test 'PATCH /users/:id redirects to edited user' do
    u = User.create(base_user_params)
    patch user_path(u), { params: { user: base_user_params }, headers: @auth_header }
    assert_redirected_to user_path(u)
  end

  private
  include SessionsHelper
  def authenticated_session
    admin = User.create(admin_user_params)
    session = create_session_for_user(admin)
  end
end