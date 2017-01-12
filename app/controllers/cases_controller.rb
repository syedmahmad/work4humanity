class CasesController < ApplicationController

	before_action :authenticate_user!
	before_action :set_case, only: [:edit, :show, :update, :destroy, :authorize_case, :allocate_funds, :confirm_funds_allocation]
	before_action :authorize_case, only: [:new, :create, :edit, :update, :destroy, :allocate_funds, :confirm_funds_allocation]
	before_action :set_hospitals, only: [:edit, :new]
	add_breadcrumb "Cases", :cases_path

	def index
		@cases = Case.all
	end

	def new
		@case = current_user.cases.build
		add_breadcrumb "New", :new_case_path
	end

	def show
		add_breadcrumb "View", :case_path
		@activity = PublicActivity::Activity.order("created_at desc").where("recipient_id = ? and key = ?", @case.id, "donation.amount_allocated")
	end

	def create
		current_user.cases.create(case_params)
		redirect_to cases_path
	end

	def edit
		add_breadcrumb "Edit", :edit_case_path
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
		@available_balance = Donation.all.received.pluck(:amount).sum
	end

	def confirm_funds_allocation
		@case.enable_funds_validation = true
		@case.form_amount = params[:case][:allocated_amount].to_i
		if @case.valid?
			@case.assign_amout_to_case
			if @case.errors.present?
				flash[:alert] = "#{@case.errors.full_messages.to_sentence}."
				redirect_to :back
			else
				flash[:notice] = 'Amount allocated to the case.'
				redirect_to :back
			end
		else
			flash[:alert] = "#{@case.errors.full_messages.to_sentence}."
			redirect_to :back
		end
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
