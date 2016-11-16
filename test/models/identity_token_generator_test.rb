require 'test_helper'
require 'base64'

class IdentityTokenGeneratorTest < ActiveSupport::TestCase
  test 'Generator has a reader for provider_id' do
    assert_equal provider_id, generator.provider_id
  end

  test 'Generator has a reader for key_id' do
    assert_equal key_id, generator.key_id
  end

  test 'Generator has a reader for private_key' do
    assert_equal private_key, generator.private_key.to_s
  end

  test '#generate_token generates an EIT' do
    assert_not_nil token_fixture
  end

  test '#generate_token parses as a JWT' do
    parts = token_fixture.split('.')
    assert_equal 3, parts.count
    assert_kind_of Hash, JSON.parse(Base64.decode64(parts[0]))  # JWT header
    assert_kind_of Hash, JSON.parse(Base64.decode64(parts[1]))  # JWT claims
  end

  test '#generate_token header has a `typ` of "JWT"' do
    assert_equal 'JWT', token_header['typ']
  end

  test '#generate_token header has a `cty` of "layer-eit;v=1"' do
    assert_equal 'layer-eit;v=1', token_header['cty']
  end

  test '#generate_token header has a `kid` equal to the `key_id`' do
    assert_equal key_id, token_header['kid']
  end

  test '#generate_token claims has an `iss` equal to the provider_id' do
    assert_equal provider_id, token_claims['iss']
  end

  test '#generate_token claims has a `prn` equal to the user ID as a string' do
    assert_equal "#{user_fixture.id}", token_claims['prn']
  end

  test '#generate_token claims has a `exp` set to sometime in the future' do
    assert token_claims['exp'] > Time.now.to_i
  end

  test '#generate_token claims has a `nce` equal to the provided nonce' do
    assert_equal nonce_fixture, token_claims['nce']
  end

  private
  def provider_id
    ENV['LAYER_PROVIDER_ID']
  end

  def key_id
    ENV['LAYER_KEY_ID']
  end

  def private_key
    ENV['LAYER_PRIVATE_KEY']
  end

  def generator
    @generator ||= IdentityTokenGenerator.new(provider_id, key_id, private_key)
  end

  def user_fixture
    @user_fixture ||= User.create(base_user_params)
  end

  def nonce_fixture
    @nonce_fixture ||= "12345687890"
  end

  def token_fixture
    @token_fixture ||= generator.generate_token(user_fixture, nonce_fixture)
  end

  def token_header
    @header ||= JSON.parse(Base64.decode64(token_fixture.split('.').first))
  end

  def token_claims
    @claims ||= JSON.parse(Base64.decode64(token_fixture.split('.').second))
  end
end