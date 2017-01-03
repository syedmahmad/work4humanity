class Attachment < ActiveRecord::Base
	belongs_to :case
	has_attached_file :attachment, :styles => { :medium => "300x300>", :thumb => "100x100>" }
	validates :attachment, :attachment_presence => true
	validates_attachment :attachment, content_type: { content_type: /\Aimage\/.*\Z/ }
end
