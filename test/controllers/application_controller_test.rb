class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test 'GET /deployed renders HTTP 200' do
    get '/deployed'
    assert_response :success
  end

  test 'GET /deployed renders "ok"' do
    get '/deployed'
    assert_equal 'ok', @response.body
  end

  test 'GET / renders HTTP 200' do
    get '/'
    assert_response :success
  end

  test 'GET / renders the `home` template' do
    get '/'
    assert_template :home
  end
end