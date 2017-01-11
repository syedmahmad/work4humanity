  class Case < ActiveRecord::Base
	validates_presence_of :title, :description, :amount_required
	validate :check_funds, :if => :enable_funds_validation

	has_many :attachments, dependent: :destroy
	belongs_to :user

	after_create :set_default_status

  	belongs_to :hospital
	accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

	enum status: [:pending, :funds_allocated]

	attr_accessor :enable_funds_validation, :form_amount

	def check_funds
		if form_amount + self.allocated_amount > self.amount_required
			errors.add(:cases, "the amount enter should not exceed the required amount for case")
		end
		if get_available_balance < form_amount
			errors.add(:cases, "the amount enter exceeds the available balance in the system")
		end
	end

	def assign_amout_to_case
		assigned_amount = 0
		detuctable_amount = 0
		requested_amount = form_amount
		required_amount = requested_amount
		total_amount = get_available_balance
		amount_to_deduct = get_avg_amount(required_amount, total_amount)

		Donation.all.received.order('id asc').each_with_index do |donation, index|
			if donation.amount <= 100
				if required_amount < donation.amount
					detuctable_amount = required_amount
					assigned_amount = assigned_amount + detuctable_amount	
				else
					detuctable_amount = donation.amount
					assigned_amount = assigned_amount + detuctable_amount
					donation.amount = 0
					donation.status = 'released'
				end
			else
				detuctable_amount = (donation.amount * (amount_to_deduct)).round
				assigned_amount = assigned_amount + detuctable_amount
				donation.amount = donation.amount - detuctable_amount
				donation.status = "released" if donation.amount == 0
			end
			
			required_amount = required_amount - detuctable_amount
			total_amount = total_amount - detuctable_amount
			amount_to_deduct = get_avg_amount(required_amount, total_amount)

			donation.save
			donation.create_activity :amount_allocated, parameters: {amount: "#{detuctable_amount}", balance: "#{get_available_balance}"}, owner: donation, recipient: self
			break if assigned_amount >= requested_amount
		end

		new_allocated_amount = assigned_amount + self.allocated_amount
		self.enable_funds_validation = false
		self.update_attributes(allocated_amount: new_allocated_amount, status: 1)
	end

	def get_avg_amount(val1, val2)
		(val1.to_f/ val2.to_f)
	end

  def get_available_balance
  	Donation.all.received.pluck(:amount).sum
  end

  private

  def set_default_status
  	self.update_column(:status, 0)
  end

end
