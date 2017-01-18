class SchedulesController < ApplicationController
  	before_action :set_user, only: [:destroy]

	def index
		@schedules = current_user.schedules
	end
	
	def destroy
		@schedule = @user.schedules.find(params[:schedule_id])
    	@schedule.destroy
    	flash[:success] = "record deleted successfully."
    	redirect_to :back
	end
	
	private
	def set_user
		@user = User.find(params[:user_id])
	end
end
