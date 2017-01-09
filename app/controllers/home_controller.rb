class HomeController < ApplicationController

  def index
    if current_user
     redirect_to "/cases"
    end
  end

  def not_authorized

  end

end
