class DonationsController < ApplicationController
  # including bcz want to use helper in controller
  include ActionView::Helpers::NumberHelper
  include LogsHelper

  before_action :authenticate_user!
  before_action :set_donation, only: [:edit, :show, :update, :destroy, :accept, :reject, :receive, :authorize_donation]
  before_action :authorize_donation, only: [:index, :new, :create, :edit, :update, :destroy, :accept, :reject, :receive, :show]

  def index
    @requested_donations = Donation.all.requested
    @accepted_donations = Donation.all.accepted
    @rejected_donations = Donation.all.rejected
    @recieved_donations = Donation.all.get_received
  end

  def new
    @donation = current_user.donations.build
    add_breadcrumb "Donations", get_donation_breadcrum_path
    add_breadcrumb "New", :new_donation_path
  end

  def create
    donation = current_user.donations.create(donation_params)
    if donation.id.present?
      flash[:notice] = "Thank you"
      amnt = formatted_ammount(donation.amount)
      SLACK_NOTIFIER.ping("#{donation.user.name.titleize} donated #{amnt}/- having phone: #{donation.user.mobile_number}")
      redirect_to donations_user_path(donation.user)
    else
      flash[:notice] = "Less than 10 million if you don't mind"
      redirect_to :back
    end

  end

  def show
    add_breadcrumb "Donations", get_donation_breadcrum_path
    add_breadcrumb "Detail", :donation_path
    @activities = PublicActivity::Activity.order("created_at desc").where("owner_id = ? and key = ?", @donation.id, "donation.amount_allocated")
  end

  def edit

  end

  def update
    @donation.update(donation_params)
    redirect_to donations_user_path(@donation.user)
  end

  def accept
    @donation.update_column(:status, 1)
    redirect_to :back
  end

  def receive
    if !@donation.received? && @donation.update_column(:status, 3)
      @donation.create_activity :amount_received, parameters: {amount: "#{@donation.amount}", balance: "#{total_remaining_ammount}"}, owner: @donation, recipient: @donation
      flash[:notice] = "Donation received."
    end
    redirect_to :back
  end

  def reject
    @donation.update_column(:status, 2)
    redirect_to :back
  end

  def destroy
    @donation.destroy
    redirect_to :back
  end

  private

    def get_donation_breadcrum_path
      @donation.user.admin? ? donations_path : donations_user_path(@donation.user)
    end

    def donation_params
      params.require(:donation).permit(:amount).merge({status: 0})
    end

    def set_donation
      if @donation = Donation.find_by_id(params[:id])
      else
        render :file => 'public/404.html', :status => :not_found, :layout => false
      end
    end

    def authorize_donation
      authorize (@donation || current_user.donations.build)
    end

end
