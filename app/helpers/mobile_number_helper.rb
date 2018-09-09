require 'zensend'
module MobileNumberHelper
	def api_call(code, number)
		client = ZenSend::Client.new(Rails.application.secrets.api_key)
		begin
		  result = client.send_sms({
		    originator: "33627244604",
		    # Add your number here to send a message to yourself
		    # The number should be in international format.
		    # For example FR numbers will be 33612345678
		    numbers: [number],
		    body: "Verify the transaction by entering the following code: #{code}"
		  })

		rescue ZenSend::ZenSendException => e
		  puts "ZenSendException: #{e.parameter} => #{e.failcode}"
		end
	end
end
