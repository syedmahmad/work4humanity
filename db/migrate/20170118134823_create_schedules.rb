class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
	  t.integer :user_id
      t.date :selected_date
      t.timestamps null: false
    end
  end
end
