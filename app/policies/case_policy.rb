class CasePolicy
	attr_reader :current_user, :model

	def initialize(current_user, model)
		@current_user = current_user
		@case = model
	end

	def new?
		true
	end

	def edit?
		@current_user.u_type == 'admin' || @case.user == @current_user
	end

	def create?
		true
	end

	def update?
		@current_user.u_type == 'admin' || @case.user == @current_user
	end

	def destroy?
		@current_user.u_type == 'admin' || @case.user == @current_user
	end

end