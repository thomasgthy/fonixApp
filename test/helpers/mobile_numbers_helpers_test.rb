require 'test_helper'
require 'mobile_numbers_helper'

class MobileNumbersHelperTest < ActionDispatch::IntegrationTest
	include MobileNumbersHelper

	setup do
		@mobile_number= MobileNumber.create!(mobile_number: "33627244604", code: "1234", ip_address: "127.0.0.1")
	end

	#Test the helper method that calls Zensend API
	test 'should send a sms' do
		assert(api_call(@mobile_number))
	end

end