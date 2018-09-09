class MobileNumber < ApplicationRecord
	# Verify that mobile_number is valid via PhoneLib gem
	validates :mobile_number, phone: true
end
