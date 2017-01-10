class AddAvailableDays < ActiveRecord::Migration
  def change
    add_column :users, :available_days, :string, array: true, default: '{}'
  end
end
