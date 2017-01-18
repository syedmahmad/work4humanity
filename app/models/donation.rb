class Donation < ActiveRecord::Base
  include PublicActivity::Common

  belongs_to :user
  enum status: { requested: 0 , accepted: 1, rejected: 2, received: 3 , released: 4}

  after_create :set_original_amount

  validates_length_of :amount, :in => 0..8, :allow_blank => true

  scope :requested, -> { where(:status => 0)}
  scope :accepted, -> { where(:status => 1)}
  scope :rejected, -> { where(:status => 2)}
  scope :received, ->  { where(:status => 3)}
  scope :released, ->  { where(:status => 4)}
  scope :get_received, -> { where("status = ? or status = ?",3,4 )}

  def status_text
    donation = self
    donation.requested? ? "waiting for approval" : donation.status
  end
  
  private

  def set_original_amount
    self.update_column(:original_amount, self.amount)
  end


end
