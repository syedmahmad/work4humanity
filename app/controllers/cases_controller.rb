class CasesController < ApplicationController

	before_action :set_case, only: [:edit]
	
	def index
		# change the below functionality to fetch the cases created by this user only
		@cases = Case.all
	end

	def new
		# change the below functionality to build a case according to a user
		@case = Case.new
	end

	def create
		#change the below code to create according to associated user
		Case.create(case_params)		
		redirect_to cases_path
	end

	def edit
			
	end

	private
	def case_params
		params.require(:case).permit(:title, :description, :amount_required, attachments_attributes: [:id, :attached_file])
	end	

	def set_case
		@case = Case.find(params[:id])
	end

end
