class ReporcessImagesByNewStyle < ActiveRecord::Migration
  def change
  	Attachment.find_each { |u| u.attachment.reprocess! }
  end
end
