class HomeController < ApplicationController

  add_breadcrumb "Home", :root_path
  def index
    if current_user
     redirect_to current_user.admin? ? "/donations" : "/cases"
    end
  end

  def not_authorized

  end

end
