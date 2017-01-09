class UsersController < ApplicationController

  # before_action :authenticate_user!
  before_action :set_user, only: [:show, :authorize_user, :donations, :update_user_role]
  before_action :authorize_user, only: [:donations, :manage_users, :update_user_role]
  before_action :validate_user_details, except: [:onboarding, :update_contact_details]

  def donations
    @donations = @user.donations
  end

  def manage_users
    @users = User.all
  end

  def onboarding
    @user = current_user || User.new
  end

  def update_contact_details
    params = request.params[:user]

    @user = User.find_by_id(params[:id]) || User.new
    @user.name = params[:name]
    @user.email = params[:email]
    @user.mobile_number = params[:mobile_number]

    if @user.save
      flash[:notice] = 'User updated'
    else
      flash[:notice] = @user.errors.full_messages.to_sentence
    end

    redirect_to root_path
  end

  def update_user_role
    if @user.update(user_role_params)
      flash[:notice] = 'User updated'
    else
      flash[:notice] = @user.errors.full_messages.to_sentence
    end

    redirect_to :back
  end

  def show

  end

  private
  def user_role_params
    params.require(:user).permit(:u_type)
  end

  def set_user
  	@user = User.find_by_id(params[:id])
  end

  def authorize_user
    authorize (@user || current_user)
  end

end
