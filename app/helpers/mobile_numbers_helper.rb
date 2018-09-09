require 'zensend'
module MobileNumbersHelper
	#Helper method called in the controller that process the request to the API
	def api_call(mobile_number)
		client = ZenSend::Client.new(Rails.application.secrets.api_key)
		begin
		  result = client.send_sms({
		    originator: "33627244604",
		    # Add your number here to send a message to yourself
		    # The number should be in international format.
		    # For example FR numbers will be 33612345678
		    numbers: [mobile_number.mobile_number],
		    body: "Verify the transaction by entering the following code: #{mobile_number.code}"
		  })
		  return true
		rescue ZenSend::ZenSendException => e
		  mobile_number.errors.add("Exception raised in the API call: ", e.failcode)
		  return false
		end
	end
end
