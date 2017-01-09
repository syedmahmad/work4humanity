class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :validate_user_details

  private

  def user_not_authorized
   	flash[:alert] = "You are not authorized to access the requested page"
    redirect_to not_authorized_path
  end

  def validate_user_details
    if current_user && !current_user.mobile_number.present? && action_name.downcase != "destroy"
      redirect_to "/users/onboarding"
    end
  end

end
