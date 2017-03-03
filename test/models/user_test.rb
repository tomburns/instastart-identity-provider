# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  first_name      :string
#  last_name       :string
#  display_name    :string
#  avatar_url      :string
#  is_admin        :boolean
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#as_json includes provided identity fields' do
    user = User.create(base_user_params.merge(first_name: 'Test', last_name: 'Layer', display_name: 'Layer Test', avatar_url: 'example.com/img'))
    user_json = user.as_json
    assert_equal 'test@layer.com', user_json["email"]
    assert_equal 'Test', user_json["first_name"]
    assert_equal 'Layer', user_json["last_name"]
    assert_equal 'Layer Test', user_json["display_name"]
    assert_equal 'example.com/img', user_json["avatar_url"]
  end

  test '#as_json excludes password_digest' do
    user = User.create(base_user_params)
    assert_nil user.as_json["password_digest"]
  end

  test 'display_name is persisted if provided upon initialization' do
    user = User.create(base_user_params.merge(display_name: 'Test display name'))
    assert_equal 'Test display name', user.display_name
  end

  test 'display_name is generated from first_name and last_name if both are provided upon initialization' do
    user = User.create(base_user_params.merge(first_name: 'First', last_name: 'Last'))
    assert_equal 'First Last', user.display_name
  end

  test 'display_name is the same as first_name if only first_name is provided upon initialization' do
    user = User.create(base_user_params.merge(first_name: 'First'))
    assert_equal 'First', user.display_name
  end

  test 'display_name is the same as last_name if only last_name is provided upon initialization' do
    user = User.create(base_user_params.merge(last_name: 'Last'))
    assert_equal 'Last', user.display_name
  end

  test 'display_name is "<User>" if neither name is provided upon initialization' do
    user = User.create(base_user_params)
    assert_equal '<User>', user.display_name
  end

  test '#as_identity includes identity fields that Layer supports' do
    user = User.create(base_user_params.merge(first_name: 'Test', last_name: 'Layer', display_name: 'Layer Test', avatar_url: 'example.com/img'))
    identity = user.as_identity
    assert_equal 'test@layer.com', identity[:email_address]
    assert_equal 'Test', identity[:first_name]
    assert_equal 'Layer', identity[:last_name]
    assert_equal 'Layer Test', identity[:display_name]
    assert_equal 'example.com/img', identity[:avatar_url]
  end

  test '#as_identity does not include fields that have not been provided' do
    user = User.create(base_user_params)
    identity = user.as_identity
    assert_nil identity["first_name"]
    assert_nil identity["last_name"]
    assert_nil identity["display_name"]
    assert_nil identity["avatar_url"]
  end
end
