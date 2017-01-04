class UsersController < ApplicationController

  before_action :authenticate_user!

  def donations
    @donations = current_user.donations
  end
end
