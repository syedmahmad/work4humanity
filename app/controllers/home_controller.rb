class HomeController < ApplicationController

  def index
    if current_user
     redirect_to current_user.donner? ? donations_user_path(current_user) : "/cases"
    end
  end

  def not_authorized

  end

end
