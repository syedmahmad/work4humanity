class DonationsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_donation, only: [:edit, :show, :update, :destroy, :accept, :reject]
  before_action :authorize_employee, only: [:new, :destroy, :accept, :reject]

  def new
    @donation = current_user.donations.build
  end

  def create
    donation = current_user.donations.create(donation_params)
    redirect_to donation_path(donation)
  end

  def show

  end

  def accept
    @donation.update_column(:status, 1)
    redirect_to :back
  end

  def reject
    @donation.update_column(:status, 2)
    redirect_to :back
  end

  private

  def donation_params
    params.require(:donation).permit(:amount).merge({status: 0})
  end

  def set_donation
    @donation = Donation.find(params[:id])
  end

end
