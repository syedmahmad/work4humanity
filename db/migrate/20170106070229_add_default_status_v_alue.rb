class AddDefaultStatusVAlue < ActiveRecord::Migration
  def change
    change_column :cases, :status, :integer, default: 0
    Case.where(status: nil).each do |case_obj|
      case_obj.update_column(:status, 0)
    end
  end
end
