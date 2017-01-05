class AddAllocatedAmountToCase < ActiveRecord::Migration
  def change
  	add_column :cases, :allocated_amount, :integer
  end
end
