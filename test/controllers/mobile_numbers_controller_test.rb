require 'test_helper'

class MobileNumbersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_mobile_number_url
    assert_response :success
  end

  test "should post create with proper parameters" do
    post mobile_numbers_url, params: { mobile_number: { mobile_number: "33627244604" } }
    assert_redirected_to mobile_number_url(MobileNumber.last)
  end

  test "should not post create with invalid mobile number" do
    post mobile_numbers_url, params: { mobile_number: { mobile_number: "1" } }
    assert_response :unprocessable_entity
  end

  test "should not post create with mobile number containing character" do
    post mobile_numbers_url, params: { mobile_number: { mobile_number: "erzett" } }
    assert_response :unprocessable_entity
  end

  test "should confirm code with a valid code" do
    post mobile_numbers_url, params: { mobile_number: { mobile_number: "33627244604" } }
    assert_redirected_to mobile_number_url(MobileNumber.last)
    post confirm_code_url(MobileNumber.last), params: { code: MobileNumber.last }
    assert :success
  end

   test "should not confirm code with a wrong code" do
    post confirm_code_url(MobileNumber.last), params: { code: MobileNumber.last }
    assert_redirected_to root_url
  end

   test "should be blocked when doing brute force on a number" do
    post mobile_numbers_url, params: { mobile_number: { mobile_number: "33627244604" } }
    assert_redirected_to mobile_number_url(MobileNumber.last)
    post mobile_numbers_url, params: { mobile_number: { mobile_number: "33627244604" } }
    assert_response :unprocessable_entity
  end
end
