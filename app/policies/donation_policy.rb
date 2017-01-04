class DonationPolicy
	attr_reader :current_user, :model

	def initialize(current_user, model)
  	@current_user = current_user
  	@donation = model
  end

  def index
  	is_admin?
  end

  private

  def is_admin?
  	current_user.is_admin?
  end	

  

end