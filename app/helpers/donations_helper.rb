module DonationsHelper

	def get_donations_path
		if current_user.u_type == 'volunteer'
			donations_user_path(current_user)
		else
			donations_path
		end
	end

  def donation_button_text(donation)
    button_text = "Create"
    if donation.persisted?
      button_text = "Update"
    else
      button_text = "Create"
    end
    button_text
  end

end
