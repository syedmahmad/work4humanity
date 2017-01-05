class AddStatusToCase < ActiveRecord::Migration
  def change
  	add_column :cases, :status, :integer
  end
end
