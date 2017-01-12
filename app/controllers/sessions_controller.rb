class SessionsController < Devise::SessionsController

  def new
    @user = User.new
    @user_type = params[:user_type]
  end

end
