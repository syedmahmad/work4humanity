class DonationsController < ApplicationController

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
    redirect_to donation_path(donation)
  end

  def show
    add_breadcrumb "Donations", get_donation_breadcrum_path
    add_breadcrumb "View", :donation_path
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
      @donation.user.admin? ? donation_path : donations_user_path(@donation.user)
    end

    def donation_params
      params.require(:donation).permit(:amount).merge({status: 0})
    end

    def set_donation
      @donation = Donation.find(params[:id])
    end

    def authorize_donation
      authorize (@donation || current_user.donations.build)
    end

end
