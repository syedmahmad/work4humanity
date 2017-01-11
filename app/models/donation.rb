class Donation < ActiveRecord::Base
  include PublicActivity::Common

  belongs_to :user
  enum status: { requested: 0 , accepted: 1, rejected: 2, received: 3 }

  after_create :set_original_amount

  scope :requested, -> { where(:status => 0)}
  scope :accepted, -> { where(:status => 1)}
  scope :rejected, -> { where(:status => 2)}
  scope :received, ->  { where(:status => 3) }

  private

  def set_original_amount
  	self.update_column(:original_amount, self.amount)
  end

end
