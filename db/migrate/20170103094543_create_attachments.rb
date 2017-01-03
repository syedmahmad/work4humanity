class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
    	t.belongs_to :case, index: true
    	t.has_attached_file :attachment
      t.timestamps null: false
    end
  end
end
