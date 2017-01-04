class DonationPolicy
	attr_reader :current_user, :model

	def initialize(current_user, model)
  	@current_user = current_user
  	@donation = model
  end

  def index?
  	is_admin?
  end

  def new?
  	is_volunteer?
  end

  def create?
  	is_volunteer?
  end

  def show?
  	is_admin? || @donation.user == current_user
  end

  def destroy?
  	is_admin?
  end

  def accept?
  	is_admin?
  end

  def reject?
  	is_admin?
  end

  def receive?
  	is_admin?
  end

  private

  def is_admin?
  	current_user.is_admin?
  end	

  def is_volunteer?
  	current_user.is_volunteer?
  end

  

end