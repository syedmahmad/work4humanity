class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user, only: [:authorize_user, :donations, :update_user_role]
  before_action :authorize_user, only: [:donations, :manage_users, :update_user_role]

  def donations
    @donations = @user.donations
  end

  def manage_users
    @users = User.all
  end

  def update_user_role
    if @user.update(user_role_params)
      flash[:notice] = 'User updated'
    else
      flash[:notice] = "@user.errors.full_messages.to_sentence"
    end
    
    redirect_to :back    
  end

  private

  def user_role_params
    params.require(:user).permit(:u_type)
  end

  def set_user
  	@user = User.find(params[:id])
  end

  def authorize_user
    authorize (@user || current_user)
  end

end
