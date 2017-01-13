class ErrorsController < ApplicationController
  def routing
    render :file => 'public/404.html', :status => :not_found, :layout => false
  end
end
