class MobileNumbersController < ApplicationController
  before_action :set_mobile_number, only: [:show, :confirm_code]
  
  def new
  	@mobile_number = MobileNumber.new
  end

  def create
	@mobile_number = MobileNumber.new(mobile_number_params)
	@mobile_number.ip_address=request.remote_ip
    validateNumberStandard; return if performed?
    #validateNumberStrict; return if performed?
    code=4.times.map{rand(10)}.join
    @mobile_number.code=code
    MobileNumber.transaction do
	   	helpers.api_call(@mobile_number) || render_error_page; return if performed?
	   	@mobile_number.save || render_error_page; return if performed?
	end
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

    def render_error_page
    	respond_to do |format|
			format.html{render :new}
		    format.json { render :show, status: :created, location: @mobile_number}
		end and return
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def mobile_number_params
      params.require(:mobile_number).permit(:mobile_number)
    end

    def validateNumberStandard
    	#Check if the same number has been used in the last 20s
    	last_time_with_same_number=MobileNumber.where(mobile_number: @mobile_number.mobile_number).last
    	if last_time_with_same_number
	    	if (last_time_with_same_number.created_at+20).to_datetime>Time.zone.now.to_datetime
	    		@mobile_number.errors.add(:mobile_number, "has been already used in the last 20s. You have to wait before re-use it")
    			render :new and return
	    	end
    	end
    end

    def validateNumberStrict
    	#Check if the same ip address has been used in the last 20s
    	last_time_with_same_ip=MobileNumber.where(ip_address: @mobile_number.ip_address).last
    	if last_time_with_same_ip
    		if (last_time_with_same_ip.created_at+20).to_datetime>Time.zone.now.to_datetime
    			@mobile_number.errors.add(:ip_address, "has been alredy detected for another confirmation in the last 20s. You have to wait before reuse it.")
    			render :new and return
    		end
    	end
    end
end
