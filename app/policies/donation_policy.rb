class DonationPolicy
	attr_reader :current_user, :model

	def initialize(current_user, model)
  	@current_user = current_user
  	@donation = model
  end

  def index?
  	is_admin? || is_volunteer? || is_donner?
  end

  def new?
  	is_volunteer? || is_admin?
  end

  def edit?
    @donation.user == current_user
  end

  def update?
    @donation.user == current_user
  end

  def create?
  	is_volunteer? || @donation.user == current_user
  end

  def show?
  	is_admin? || @donation.user == current_user
  end

  def destroy?
  	is_admin? || @donation.user == current_user
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

  def is_donner?
    current_user.donner?
  end

  def is_volunteer?
  	current_user.is_volunteer?
  end



end
