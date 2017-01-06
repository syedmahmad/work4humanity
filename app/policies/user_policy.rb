class UserPolicy
	attr_reader :current_user, :model

	def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def donations?
  	@user == current_user
  end

  def manage_users?
  	@current_user.is_admin?
  end

  def update_user_role?
  	@current_user.is_admin?
  end

end