require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'GET /users renders users#index' do
    get '/users'
    assert_template :index
  end

  test 'GET /users/:id renders users#show' do
    u = User.create(base_user_params)
    get user_path(u)
    assert_template :show
  end

  test 'POST /users creates a new user record with the provided parameters' do
    before_count = User.count
    post '/users', params: { user: base_user_params }
    after_count = User.count
    assert_equal (before_count + 1), after_count
    assert_equal base_user_params[:email], User.last.email
  end

  test 'POST /users redirects to newly created user' do
    post '/users', params: { user: base_user_params }
    assert_redirected_to user_path(User.last)
  end

  test 'GET /users/:id/edit renders users#edit' do
    u = User.create(base_user_params)
    get edit_user_path(u)
    assert_template :edit
  end

  test 'PATCH /users/:id updates the referenced user record with the provided parameters' do
    u = User.create(base_user_params)
    patch user_path(u), params: { user: { email: 'new@email.com' } }
    assert_equal 'new@email.com', u.reload.email
  end

  test 'PATCH /users/:id redirects to edited user' do
    u = User.create(base_user_params)
    patch user_path(u), params: { user: base_user_params }
    assert_redirected_to user_path(u)
  end
end