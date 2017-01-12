class RegistrationsController < Devise::RegistrationsController

  def create
    user = User.find_by_mobile_number(params[:user][:mobile_number])
    if user.valid_password?(params[:user][:password])
      sign_in(user)
      redirect_to root_path
    else
      redirect_to :back
    end
  end
end
