  class UsersController < ApplicationController

  # before_action :authenticate_user!
  before_action :set_user, only: [:show, :authorize_user, :donations, :update_user_role]
  before_action :authorize_user, only: [:donations, :manage_users, :update_user_role]
  before_action :validate_user_details, except: [:onboarding, :update_contact_details]


  def donations
    @donations = @user.donations
    add_breadcrumb "Donations", :donations_user_path
  end

  def manage_users
    @users = User.all
  end

  def onboarding
    @user = current_user || User.new
    @user.u_type = params[:user_type].downcase if params[:user_type].present?
  end

  def create
    ffadsfasdfa
  end

  def update_contact_details
    path = "#{root_path}"
    @user = User.find_by_id(params[:user][:id]) || User.new
    @user.assign_attributes(user_contact_params)

    @user.skip_confirmation!
    if @user.save
      sign_in(@user)
      flash[:notice] = 'Successfully Registered!'
    else
      flash[:notice] = @user.errors.full_messages.to_sentence
      path = :back
    end

    redirect_to path
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
    if Rails.application.routes.recognize_path(request.referer)[:controller].downcase == "logs"
      add_breadcrumb "Logs", :logs_path
    end
    add_breadcrumb "Profile", :user_path
  end

  private

  def user_contact_params
    params[:user][:available_days] = params[:available_days].reject(&:empty?) if params[:available_days].present? && params[:available_days].any?
    params.require(:user).permit(:name, :email, :mobile_number, :u_type , :password, available_days: [])
  end

  def user_role_params
    params.require(:user).permit(:u_type)
  end

  def set_user
  	if @user = User.find_by_id(params[:id])
    else
      render :file => 'public/404.html', :status => :not_found, :layout => false
    end
  end

  def authorize_user
    authorize (@user || current_user)
  end

end
