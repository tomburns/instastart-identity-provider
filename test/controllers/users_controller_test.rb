require 'test_helper'

class UsersControllerUnauthenticatedTest < ActionDispatch::IntegrationTest
  setup do
    stub_request(:post, /api.layer.com/)
      .to_return(status: 200, body: "")
  end
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
    stub_request(:post, /api.layer.com/)
      .to_return(status: 200, body: "")
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

  test "POST /users calls Layer's Server API to create an Identity" do
    post '/users', { params: { user: base_user_params }, headers: @auth_header }
    assert_requested :post, /api.layer.com\/apps\/.+\/users\/.+\/identity/,
      headers: {
        'Accept' => 'application/vnd.layer+json; version=2.0',
        'Content-Type' => 'application/json',
        'Authorization' => /Bearer .+/
      },
      body: {
        display_name: '<User>',
        email_address: base_user_params[:email]
      }.to_json,
      times: 1
  end

  test "POST /users automatically has new user follow other users if there are only a few users in the database" do
    user_1 = User.create(base_user_params.merge(email: 'user1@example.com'))
    post '/users', { params: { user: base_user_params }, headers: @auth_header }
    new_user_id = User.find_by(email: base_user_params[:email]).id
    assert_requested :post, Regexp.new("api.layer.com\/apps\/.+\/users\/#{new_user_id}/following/users"),
      headers: {
        'Accept' => 'application/vnd.layer+json; version=2.0',
        'Content-Type' => 'application/json',
        'Authorization' => /Bearer .+/
      },
      body: User.all.pluck(:id).reject{ |id| id == new_user_id }.to_json,
      times: 1
  end

  test "POST /users does not automatically follow other users if there a lot of users in the database" do
    100.times { |i| User.create(base_user_params.merge(email: "user#{i}@example.com")) }
    post '/users', { params: { user: base_user_params }, headers: @auth_header }
    assert_not_requested :post, /api.layer.com\/apps\/.+\/users\/.+\/following\/users/
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
    assert_redirected_to user_path(User.find_by_email(base_user_params[:email]))
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