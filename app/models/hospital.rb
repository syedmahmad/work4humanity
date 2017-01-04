class Hospital < ActiveRecord::Base
  validates_presence_of :name, :city

  has_many :cases
end
