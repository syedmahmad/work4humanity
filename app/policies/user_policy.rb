class UserPolicy
	attr_reader :current_user, :model

	def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def donations?
  	puts "@@@@@@@@@@@!!!!!!!!!!!!!!!!!!!!!\n"*12
  	puts @user == current_user
  	@user == current_user
  end

end