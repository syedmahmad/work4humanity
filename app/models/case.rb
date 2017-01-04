  class Case < ActiveRecord::Base
	validates_presence_of :title, :description, :amount_required
	has_many :attachments, dependent: :destroy
	belongs_to :user
  belongs_to :hospital
	accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
