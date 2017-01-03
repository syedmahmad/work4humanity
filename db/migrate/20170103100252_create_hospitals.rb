class CreateHospitals < ActiveRecord::Migration
  def change
    create_table :hospitals do |t|
      t.string :name
      t.string :city
      t.string :desc

      t.timestamps null: false
    end
  end
end
