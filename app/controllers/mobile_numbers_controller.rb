class MobileNumbersController < ApplicationController
  before_action :set_mobile_number, only: [:show, :confirm_code]
  
  def new
  	@mobile_number = MobileNumber.new
  end

  def create
	 @mobile_number = MobileNumber.new(mobile_number_params)
	 @mobile_number.ip_address=request.remote_ip
    validateNumber; return if performed?
    code=4.times.map{rand(10)}.join
    @mobile_number.code=code
    helpers.api_call(@mobile_number.code)
    respond_to do |format|
       if @mobile_number.save
        format.html { redirect_to @mobile_number, notice: 'Mobile Number was successfully approved.' }
        format.json { render :show, status: :created, location: @mobile_number }
      else
        format.html { render :new }
        format.json { render json: @mobile_number.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def confirm_code
  	if(params[:code]==@mobile_number.code)
  		puts "SUCCESS"
  	else
  		puts "NOPE"
  	end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_mobile_number
      @mobile_number = MobileNumber.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mobile_number_params
      params.require(:mobile_number).permit(:mobile_number)
    end

    def validateNumber
    	#Check if the same number has been used in the last 20s
    	last_time_with_same_number=MobileNumber.where(mobile_number: @mobile_number.mobile_number).last
    	#Check if the same ip address has been used in the last 20s
    	last_time_with_same_ip=MobileNumber.where(ip_address: @mobile_number.ip_address).last
    	if last_time_with_same_number
	    	if (last_time_with_same_number.created_at+20).to_datetime>Time.zone.now.to_datetime
	    		puts "STP 1"
	    		@mobile_number.errors.add(:mobile_number, "has been already used 20s ago. You have to wait before re-use it")
    			render :new and return
	    	end
    	elsif last_time_with_same_ip
    		if (last_time_with_same_ip.created_at+20).to_datetime>Time.zone.now.to_datetime
	    		puts "STP 2"
    			@mobile_number.errors.add(:ip_address, "has been alredy detected for another confirmation 20s ago. You have to wait before reuse it.")
    			render :new and return
    		end
    	end
    	return true
    end
end
