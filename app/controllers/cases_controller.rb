class CasesController < ApplicationController

	before_action :authenticate_user!, :except => [:index, :show]
	before_action :set_case, only: [:approve, :deny, :edit, :show, :update, :destroy, :authorize_case, :allocate_funds, :confirm_funds_allocation]
	before_action :authorize_case, only: [:new, :create, :edit, :update, :destroy, :allocate_funds, :confirm_funds_allocation]
	before_action :set_hospitals, only: [:edit, :new]
	add_breadcrumb "Cases", :cases_path

	# adding identifier for newly created case
	# after_action :add_case_identifier, only: [:create]

	def index
		@cases = current_user.present? && current_user.admin? ? Case.all : Case.approved_cases
	end

	def new
		@case = current_user.cases.build
		add_breadcrumb "New", :new_case_path
	end

	def show
		add_breadcrumb "Detail", :case_path
		@activity = PublicActivity::Activity.order("created_at desc").where("recipient_id = ? and key = ?", @case.id, "donation.amount_allocated")
	end

	def create
		case_created = current_user.cases.create(case_params)
		if case_created.id.present?
      flash[:notice] = "Thank you. Your case has submitted for approval."
			redirect_to cases_path
    else
      flash[:notice] = "Required Amount must less than 10 million if you don't mind"
      redirect_to :back
    end
	end

	def edit
		add_breadcrumb "Edit", :edit_case_path
	end

	def update
		params[:case][:status] = 0 if @case.deny?
		@case.update(case_params)
		redirect_to case_path
	end

	def destroy
		@case.destroy
		redirect_to cases_path
	end

	def allocate_funds
		@available_balance = Donation.all.received.pluck(:amount).sum
		add_breadcrumb "View", :case_path
		add_breadcrumb "Allocate fund", :allocate_funds_case_path
	end

	def approve
		@case.update_column(:status, 3)
		flash[:success] = 'Case has been approved.'
		redirect_to :back
	end

	def deny
		@case.update_column(:status, 2)
		flash[:success] = 'Case has been denied.'
		redirect_to :back
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
		params.require(:case).permit(:title, :description, :status, :amount_required, :hospital_id, attachments_attributes: [:id, :attachment, :_destroy])
	end

	def set_case
		if @case = Case.find_by_id(params[:id])
		else
      render :file => 'public/404.html', :status => :not_found, :layout => false
    end
	end

	def set_hospitals
		@hospitals = Hospital.all
	end

	def authorize_case
		authorize (@case || current_user.cases.build)
	end

end
