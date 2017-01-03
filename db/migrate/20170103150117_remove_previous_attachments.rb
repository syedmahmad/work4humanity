class RemovePreviousAttachments < ActiveRecord::Migration
  def change
    Attachment.all.destroy_all
  end
end
