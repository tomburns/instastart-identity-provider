# These are demo values only
ENV['LAYER_KEY_ID'] = 'layer:///keys/074c4f14-a6dd-11e6-bfe9-455cd2013b06'
ENV['LAYER_PROVIDER_ID'] = 'layer:///providers/cf0eb712-d9ab-11e5-b6a9-c01d00006542'
ENV['LAYER_PRIVATE_KEY'] = <<-eof
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEA1yUQrlQscdh5SnsgRkO4gFuGCSodr9KyonCaX6tLlXNdp424
+JA6W+V8bN3GA6Ssxlzr7vAM3YK0btWdi90tKZHHXTQYBilXwd2K6PFaGx9lOhMb
gl0AJyjgK8IERf2LerPFQuAq4+s+h6tn6j/eBJBtoGwjWOxkKncy4FswAF5JUIed
Prka6fVn2+ohe+WO+kBzmhXemyf94voitSSx6NGrTFHvtTeOpoKo8pPouyh6qTUz
FMwKQK44CcLlGAbjTAiqj18Qg2kOCEwoGYTwGthVZBfZd6RKeL67/RfdXt05choR
LkAGKf0t6NbeJvaB+1oT6Ux/qaxq8K6Eq4kLBQIDAQABAoIBADZepZKIrxquLCjI
aOWY4518g6j5PbtbMc2fS0P2FAnWt8pKJH6cZEMpAYK5oPr2uLsAbJdbjsTD7Tk9
Pq1D3c/tiUZijdewxv61MA+iPrUv//LnNUKCojFDQTONumq9omwF1koKQIyMvKao
iIBIV6Erpqit61jjlISuzuqn4L+WnV+R4H+zDFfRWy2HKs1JkT/mF9XwMEfCrt/8
BwXjNd8aT2vFm6aC7vyQT2QhqzHTT7ecDNT3FpUgV58MvrYl74yTMT4r/AUrvZYd
9obRIYdCiVsssNzMhVq8mDKCv5TkKPURh3tEf1orDUIEw3kXl2gwxsLSNV1a8B4H
02ZU8IECgYEA/DiyNYhUjehkZZaT4iAgF4uwNIieaQvaMRZf8A/CCK8krwO7q2Wp
9ekjqkCKrTXh5WdsKbUGDULx3zMFkdJbW3lDtHy6ksgcHJDuGxnUjCYMxPf6WbQ2
kkkukflQBv8A9JVyC+3t9wrf1+kVlsUVbZEyXE2IXsUqJXIHcR9kgPUCgYEA2l4s
xHYhGHJIt1oq7oLPaZ8b29VWmBd3PvxZycFzquPLHmFtETU0im8rTqHxv4gklaUF
9ikmOyARKfOTqB4e8A7S99hB9v1t+o6nF0f4uWWZkQOf7N4GN3CbdtmpMzcWsvWI
4agha+pea0hHfCeurpY8YlKTzotJNk0JTKS219ECgYAt+IN6wFtw9f9+iKBxoZtX
z00RdikxSki9k69uyOB7xrhv8cU96yy8Nn8ao+LiySRgNKaBP45X0nDVVq5YMrgW
BxcxCV7ULAb7qerMI7waw0CmkfAec3tS1GXZk1Bjxgy9h5Oe2wH5ehDsgH4/2bIb
I1DDhBor89HHu23hz2/5FQKBgHv1p+4irOjmv1auLd7VjQ6FTtg9Q/n0oDG2KPY6
BgJFa6GkZri0/k1zjB8IGWbDzxjP5BF4DIbVzkiFSBXQe3mEwMgHEHM4LD1my32Q
0qXUAhfq+dcJtne0Sdxu9Pjo1c7jST/oJIjRM6YtEr9s+2GKUV7zR4qhUP8tPhEv
E8hxAoGBAMtNv2Lh43qtJP8n1PyF61lTOqHfaB2Z5DUhN2HzuBjdIPQLTB+UGrbk
/SjgfEdhz8oXmyG7UQfuruuiyyn5xC9v3ZThCBsNL8AG5s3dLMAynQIJ43SmeKM9
wyVcNgU9giA/GP3JL8SK5jNI8f4hbAZr4s/UIj61TbfNQPl8sWib
-----END RSA PRIVATE KEY-----
eof

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => 'public, max-age=3600'
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
end
