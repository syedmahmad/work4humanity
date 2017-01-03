class Case < ActiveRecord::Base
	validates_presence_of :title, :description, :amount_required
	has_many :attachments
	accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
