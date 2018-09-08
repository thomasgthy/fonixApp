require 'test_helper'

class MobileNumberControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get mobile_number_new_url
    assert_response :success
  end

  test "should get create" do
    get mobile_number_create_url
    assert_response :success
  end

end
