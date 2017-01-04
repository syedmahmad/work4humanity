module DonationsHelper

	def get_donations_path
		if current_user.u_type == 'volunteer'
			donations_user_path(current_user)
		else	
			donations_path
		end		
	end

end
