class Case < ActiveRecord::Base
	validates_presence_of :title, :description, :amount_required
	validate :check_funds, :if => :enable_funds_validation	

	has_many :attachments, dependent: :destroy
	belongs_to :user
	
	after_create :set_default_status

	accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
	
	enum status: [:pending, :funds_allocated]

	attr_accessor :enable_funds_validation, :form_amount

	def check_funds
		if get_available_balance < form_amount
			errors.add(:cases, "the amount enter exceeds the available balance in the system")
		end	
	end

	def assign_amout_to_case
		assigned_amount = 0
		break_loop = false
		Donation.all.order('id asc').each_with_index do |donation, index|
			unless assigned_amount == form_amount
				if donation.amount <= form_amount
					assigned_amount = assigned_amount + donation.amount
					donation.amount = 0 
				else	
					amount_to_deduct = form_amount - assigned_amount
					assigned_amount = assigned_amount + amount_to_deduct
					donation.amount = donation.amount - amount_to_deduct
				end
				donation.save
			else
				break_loop =  true
			end
			break if break_loop
		end
		new_allocated_amount = assigned_amount + self.allocated_amount
		self.enable_funds_validation = false
		self.update_attributes(allocated_amount: new_allocated_amount, status: 1)
	end

	def get_available_balance
  	Donation.all.received.pluck(:amount).sum
  end

  private

  def set_default_status
  	self.update_column(:status, 0)
  end

end
