require "test_helper"

class Api::AuthControllerTest < ActionDispatch::IntegrationTest
  test "should get register" do
    get api_auth_register_url
    assert_response :success
  end
end
