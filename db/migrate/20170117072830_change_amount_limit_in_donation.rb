class ChangeAmountLimitInDonation < ActiveRecord::Migration
  def up
    change_column :donations, :amount, :integer, limit: 8
  end
  def down
    change_column :donations, :amount, :integer, limit: 4
  end
end
