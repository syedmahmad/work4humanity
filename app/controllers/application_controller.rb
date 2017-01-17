class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception
  # To prevent back button come to unauthorized page after logout
  before_filter :set_cache_buster

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :validate_user_details

  private

  def process(action, *args)
    super
  rescue AbstractController::ActionNotFound
    render :file => 'public/404.html', :status => :not_found, :layout => false
  end

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def total_remaining_ammount
    Donation.all.received.pluck(:amount).sum
  end

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
