class MobileNumbersController < ApplicationController
  before_action :set_mobile_number, only: [:show, :confirm_code]
  
  def new
  	@mobile_number = MobileNumber.new
  end

  # Create a mobile number and call the API method
  def create
	@mobile_number = MobileNumber.new(mobile_number_params)
	#Store the ip address for security purpose
	@mobile_number.ip_address=request.remote_ip
	#Validate the number for security reasons
    validateNumberStandard(20); return if performed?
    validateNumberStrict(20); return if performed?
    #Create the random code
    code=4.times.map{rand(10)}.join
    @mobile_number.code=code
    #Open a tansaction
    MobileNumber.transaction do
    	#Save the mobile number or render the error page
   		@mobile_number.save || render_error_page; return if performed?
   		#Call the API or render the error page
   		helpers.api_call(@mobile_number) || render_error_page; return if performed?
	end
	#Redirect ot the next view to confirm the code
   	respond_to do |format|
	   	format.html {
	        flash[:success] = 'Mobile Number was successfully approved.'
	       	redirect_to @mobile_number
	    }
	    format.json { render :show, status: :created, location: @mobile_number }
	end
  end

  def show
  end

  #Confirm the code
  def confirm_code
  	if(params[:code]==@mobile_number.code)
  		flash[:success] = "Validation successful !"
  		render :show
  	else
  		flash[:danger] = "The code is not correct."
  		redirect_to root_path
  	end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_mobile_number
      @mobile_number = MobileNumber.find(params[:id])
    end

    #Render the error page
    def render_error_page
    	respond_to do |format|
			format.html{render :new, status: :unprocessable_entity}
		    format.json { render json: @mobile_number.errors, status: :unprocessable_entity}
		end and return
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mobile_number_params
      params.require(:mobile_number).permit(:mobile_number)
    end

    #Light security check to avoid a random mobile number to be spammed
    def validateNumberStandard(delay)
    	#Check if the same number has been used in the last 20s
    	last_time_with_same_number=MobileNumber.where(mobile_number: @mobile_number.mobile_number).last
    	if last_time_with_same_number
	    	if (last_time_with_same_number.created_at+delay).to_datetime>Time.zone.now.to_datetime
	    		@mobile_number.errors.add(:mobile_number, "has been already used in the last 20s. You have to wait before re-use it")
    			render :new, status: :unprocessable_entity and return
	    	end
    	end
    end

    #Strong security based on the ip address, comment the call in the create action
    #if the application will be used as an API in a script for broadcasting to a lot of numbers
    def validateNumberStrict(delay)
    	#Check if the same ip address has been used in the last 20s
    	last_time_with_same_ip=MobileNumber.where(ip_address: @mobile_number.ip_address).last
    	if last_time_with_same_ip
    		if (last_time_with_same_ip.created_at+delay).to_datetime>Time.zone.now.to_datetime
    			@mobile_number.errors.add(:ip_address, "has been alredy detected for another confirmation in the last 20s. You have to wait before reuse it.")
    			render :new , status: :unprocessable_entity and return
    		end
    	end
    end
end
