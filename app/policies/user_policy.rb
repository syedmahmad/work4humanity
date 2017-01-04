class UserPolicy
	attr_reader :current_user, :model

	def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def donations?
  	@user == current_user
  end

end