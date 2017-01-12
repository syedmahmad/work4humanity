class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :validate_user_details

  private

  def process(action, *args)
    super
  rescue AbstractController::ActionNotFound
    render :file => 'public/404.html', :status => :not_found, :layout => false
    # render :404, status: 'not_found'
    # respond_to do |format|
    #   format.html { render :404, status: :not_found }
    #   format.all { render nothing: true, status: :not_found }
    # end
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
