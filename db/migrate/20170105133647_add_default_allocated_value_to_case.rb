class AddDefaultAllocatedValueToCase < ActiveRecord::Migration
  def change
  	change_column :cases, :allocated_amount, :integer, :default => 0
  end
end
