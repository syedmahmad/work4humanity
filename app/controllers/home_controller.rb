class HomeController < ApplicationController

  def index
    if current_user
     redirect_to current_user.u_type.to_i == 0 ? "/cases" : "/donations"
    end
  end

  def not_authorized

  end

end
