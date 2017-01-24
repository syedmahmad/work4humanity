class HomeController < ApplicationController

  def index
    if current_user
     redirect_to current_user.donner? ? donations_user_path(current_user) : schedule_availability_user_path(current_user)
    end
  end

  def not_authorized

  end

  def contact_us

  end

end
