class CasesController < ApplicationController

	before_action :authenticate_user!
	before_action :set_case, only: [:edit, :show, :update, :destroy, :authorize_case]
	before_action :authorize_case, only: [:new, :create, :edit, :update, :destroy]
	before_action :set_hospitals, only: [:edit, :new]

	def index
		@cases = Case.all
	end

	def new
		@case = current_user.cases.build
	end

	def show

	end

	def create
		current_user.cases.create(case_params)
		redirect_to cases_path
	end

	def edit

	end

	def update
		@case.update(case_params)
		redirect_to case_path
	end

	def destroy
		@case.destroy
		redirect_to cases_path
	end

	private
	def case_params
		params.require(:case).permit(:title, :description, :amount_required, :hospital_id, attachments_attributes: [:id, :attachment, :_destroy])
	end

	def set_case
		@case = Case.find(params[:id])
	end

	def set_hospitals
		@hospitals = Hospital.all
	end

	def authorize_case
		authorize (@case || current_user.cases.build)
	end

end
