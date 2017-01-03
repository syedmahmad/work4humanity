class Attachment < ActiveRecord::Base
	belongs_to :case
	has_attached_file :attachment, :path => "/uploaded_attachments/:class/:attachment/:id_partition/:style/:filename"
	validates :attachment, :attachment_presence => true
	validates_attachment :attachment, content_type: { content_type: /\Aimage\/.*\Z/ }
end
