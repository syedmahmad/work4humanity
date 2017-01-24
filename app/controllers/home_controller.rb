class HomeController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => :send_mail
  def index
    if current_user
     redirect_to current_user.donner? ? donations_user_path(current_user) : schedule_availability_user_path(current_user)
    end
  end

  def not_authorized

  end

  def contact_us

  end

  def send_mail
    rr = ContactMailer.contact_us(params).deliver
    flash[:notice] = "Thank you for contacting us. We will contact you soon."
    redirect_to :back
  end

end
