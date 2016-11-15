require 'test_helper'

class AuthenticationRequestTest < ActiveSupport::TestCase
  test '#valid? returns true if initialized with an email and password that matches a user' do
    User.create(base_user_params)
    request = AuthenticationRequest.new(base_user_params[:email], base_user_params[:password])
    assert request.valid?
  end

  test '#valid? returns false if initialized with an email and password that does not match a user' do
    User.create(base_user_params)
    request = AuthenticationRequest.new(base_user_params[:email], 'wrongpassword')
    assert_not request.valid?
  end
end