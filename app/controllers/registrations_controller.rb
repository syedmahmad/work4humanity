class RegistrationsController < Devise::RegistrationsController

  def create
    phone = params[:user][:mobile_number].gsub(/[^0-9a-z ]/i, '')
    params[:user][:mobile_number] = phone
    path = :back
    user = User.find_by_mobile_number(params[:user][:mobile_number])
    if user
      if user.valid_password?(params[:user][:password])
        sign_in(user)
        path = root_path
      else
        flash[:error] = "Please enter valid password."
      end
    else
      flash[:error] = "The phone number you entered is not associated with any account."
    end
    redirect_to path
  end
end
