class CasePolicy
	attr_reader :current_user, :model

	def initialize(current_user, model)
		@current_user = current_user
		@case = model
	end

end