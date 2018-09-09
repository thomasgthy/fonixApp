require 'test_helper'

class MobileNumberTest < ActiveSupport::TestCase
	setup do
		@wrong_mobile_number1= MobileNumber.new(mobile_number: "12", ip_address: "192.98.75.4", code: "1234")
		@wrong_mobile_number2= MobileNumber.new(mobile_number: "0627244604", ip_address: "192.98.75.4", code: "1234")
		@wrong_mobile_number3= MobileNumber.new(mobile_number: "'§(è!çà", ip_address: "192.98.75.4", code: "1234")
		@mobile_number= MobileNumber.new(mobile_number: "442081147000", ip_address: "192.98.75.4", code: "1234")
    end

  test "should save valid number" do
   	assert @mobile_number.save
  end

  test "should not save wrong number 1" do
   	assert_not @wrong_mobile_number1.save
  end

  test "should not save wrong number 2" do
   	assert_not @wrong_mobile_number2.save
  end

  test "should not save wrong number 3" do
   	assert_not @wrong_mobile_number3.save
  end
end
