class Attachment < ActiveRecord::Base
	belongs_to :case
	has_attached_file :attached_file
	validates :attached_file, :attachment_presence => true
	validates_attachment :attached_file, content_type: { content_type: /\Aimage\/.*\Z/ }
end
