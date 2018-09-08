class MobileNumbersController < ApplicationController
  def new
  	@mobile_number = MobileNumber.new
  end

  def show
  end

  def create
	 @mobile_number = MobileNumber.new(mobile_number_params)
	 @mobile_number.ip_address=request.remote_ip
    respond_to do |format|
      if @mobile_number.save && validateNumber
        format.html { redirect_to new_confirmation_path, notice: 'Mobile Number was successfully approved.' }
        format.json { render :show, status: :created, location: @mobile_number }
      else
        format.html { render :new }
        format.json { render json: @mobile_number.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def mobile_number_params
      params.require(:mobile_number).permit(:mobile_number)
    end

    def validateNumber
    	#Check if the same number has been used in the last 20s
    	last_time_with_same_number=MobileNumber.where(mobile_number: @mobile_number.mobile_number).last
    	if last_time_with_same_number
	    	if (last_time_with_same_number.created_at+20).to_datetime>Time.now.to_datetime
	    		@mobile_number.errors.add(:mobile_number, "has been already used 20s ago. You have to wait before re-use it")
	    		return false
	    	end
		end

    	#Check if the same ip address has been used in the last 20s
    	last_time_with_same_ip=MobileNumber.where(ip_address: @mobile_number.ip_adress).last
    	if last_time_with_same_ip
    		if (last_time_with_same_ip.created_at+20).to_datetime>Time.now.to_datetime
    			@mobile_number.errors.add(:ip_address, "has been alredy detected for another confirmation 20s ago. You have to wait before reuse it.")
    			return false
    		end
    	end
    	return true
    end
end
