class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user, only: [:authorize_user, :donations]
  before_action :authorize_user, only: [:donations]

  def donations
    @donations = @user.donations
  end

  private

  def set_user
  	@user = User.find(params[:id])
  end

  def authorize_user
    authorize @user
  end

end
