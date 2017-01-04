class CasesController < ApplicationController

	before_action :authenticate_user!
	before_action :set_case, only: [:edit, :show, :update, :destroy, :authorize_case, :allocate_funds, :confirm_funds_allocation]
	before_action :authorize_case, only: [:new, :create, :edit, :update, :destroy, :allocate_funds, :confirm_funds_allocation]

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

	def allocate_funds
		@available_balance = Donation.all.pluck(:amount).sum
	end

	def confirm_funds_allocation
		
	end

	private
	def case_params
		params.require(:case).permit(:title, :description, :amount_required, attachments_attributes: [:id, :attachment, :_destroy])
	end

	def fund_allocation_params
		params.require(:case).permit(:allocated_amount)
	end

	def set_case
		@case = Case.find(params[:id])
	end

	def authorize_case
		authorize (@case || current_user.cases.build)
	end

end
