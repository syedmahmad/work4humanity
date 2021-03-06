  class UsersController < ApplicationController
  respond_to :xlsx, :html, :js
  before_action :authenticate_user!, only: [:manage_users, :donations, :update_user_role, :schedule_availability, :change_image]
  before_action :set_user, only: [:show, :cases, :authorize_user, :donations, :update_user_role, :change_image, :update_availability_details]
  before_action :authorize_user, only: [:donations, :manage_users, :update_user_role]
  before_action :validate_user_details, except: [:onboarding, :update_contact_details]


  def donations
    @donations = @user.donations
    add_breadcrumb "Donations", :donations_user_path
  end

  def cases
    @user_cases = current_user ? current_user.cases : []
    add_breadcrumb "My Cases", :cases_user_path
  end

  def manage_users
    @users = User.all
  end

  def change_image
    @record_updated = @user.update(user_avatar_params) ? true : false
    respond_to do |format|
      format.js {}
    end
  end

  def onboarding
    @user = current_user || User.new
    @user.u_type = params[:user_type].downcase if params[:user_type].present?
  end

  def create
  end

  def update_availability_details
    if params[:user][:available_days].present?
      dates = params[:user][:available_days].split(',');
      dates.each do |d|
        date = d.to_date
        @user.schedules.find_or_create_by(selected_date: date)
      end
      flash[:success] = "Thanks we’ve registered your time availability"
      redirect_to user_schedules_path(@user)
    else
      flash[:error] = "Please select your schedule."
      redirect_to :back
    end
  end

  def volunteers
    @schedules = Schedule.all
  end

  def update_contact_details
    phone = params[:user][:mobile_number].gsub(/[^0-9a-z ]/i, '')
    params[:user][:mobile_number] = phone
    @user = User.find_by_id(params[:user][:id]) || User.new
    @user.assign_attributes(user_contact_params)

    @user.skip_confirmation!
    if @user.save
      sign_in(@user)
      flash[:notice] = 'Successfully Registered!'
      path = @user.volunteer? ? schedule_availability_user_path(@user) : root_path
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
    # todo: latter will be used for breadcrums
    # if Rails.application.routes.recognize_path(request.referer)[:controller].downcase == "logs"
    #   add_breadcrumb "History", :logs_path
    # end
    add_breadcrumb "Profile", :user_path
  end

  def schedule_availability
    @user = current_user
  end

  # def add_availability_field
  #   render :partial =>'set_availability_field'
  # end

  private

  def user_contact_params
    params[:user][:available_days] = params[:available_days].reject(&:empty?) if params[:available_days].present? && params[:available_days].any?
    params.require(:user).permit(:name, :email, :mobile_number, :u_type , :password, available_days: [])
  end

  def user_role_params
    params.require(:user).permit(:u_type)
  end

  def user_avatar_params
    params.require(:user).permit(:avatar)
  end

  def set_user
  	if @user = User.find_by_id(params[:id]) || User.find(params[:user][:id])
    else
      render :file => 'public/404.html', :status => :not_found, :layout => false
    end
  end

  def authorize_user
    authorize (@user || current_user)
  end

end
