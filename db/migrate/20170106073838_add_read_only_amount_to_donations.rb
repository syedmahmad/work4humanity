class AddReadOnlyAmountToDonations < ActiveRecord::Migration
  def change
  	add_column :donations, :original_amount, :integer
  end
end
