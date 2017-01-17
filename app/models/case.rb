  class Case < ActiveRecord::Base
	validates_presence_of :title, :description, :amount_required
	validate :check_funds, :if => :enable_funds_validation

	validates_length_of :amount_required, :in => 0..8, :allow_blank => true

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
		break_loop = false
		assigned_amount = 0
		detuctable_amount = 0

		requested_amount = form_amount
		required_amount = requested_amount
		total_amount = get_available_balance
		amount_to_deduct = get_avg_amount(required_amount, total_amount)

		donations = Donation.all.received.order('id asc')

		record_hash = {}
		while assigned_amount < requested_amount
			donations.each_with_index do |donation, index|
				if donation.amount > 0
					min_limit_flag = donation.amount <= 100

					if min_limit_flag
						detuctable_amount = required_amount < donation.amount ? required_amount : donation.amount
						assigned_amount = assigned_amount + detuctable_amount
					else
						avg_amount_to_fund = (donation.amount * (amount_to_deduct)).round

						detuctable_amount = min_limit_flag ? (donation.amount > required_amount ? required_amount : donation.amount) : (avg_amount_to_fund > required_amount ? required_amount : avg_amount_to_fund)

						detuctable_amount = detuctable_amount < 1 ? 1 : detuctable_amount
						assigned_amount = assigned_amount + detuctable_amount
					end

					donation.amount = donation.amount - detuctable_amount
					required_amount = required_amount - detuctable_amount
					total_amount = total_amount - detuctable_amount
					amount_to_deduct = get_avg_amount(required_amount, total_amount)

					donation.save
					record_hash[donation.id] = record_hash[donation.id].present? ? record_hash[donation.id] + detuctable_amount : detuctable_amount

					break_loop = assigned_amount >= requested_amount
					break if break_loop
				end
			end

			break if break_loop
			donations = donations.reload.received.order('id asc')
		end

		donations.each do |donation|
			if donation.amount == 0
				donation.status = "released"
				donation.save
			end
			donation.create_activity :amount_allocated, parameters: {amount: record_hash[donation.id]}, owner: donation, recipient: self
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
