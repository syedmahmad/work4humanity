class Donation < ActiveRecord::Base
  include PublicActivity::Common
  
  belongs_to :user
  enum status: { requested: 0 , accepted: 1, rejected: 2, received: 3 }

  scope :received, ->  { where(:status => 3) }

end
