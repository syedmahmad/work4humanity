class HomeController < ApplicationController

  add_breadcrumb "Home", :root_path
  def index
    if current_user
     redirect_to current_user.u_type.to_i == 0 ? "/cases" : "/donations"
    end
  end

  def not_authorized

  end

end
