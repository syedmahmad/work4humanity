class CreateCases < ActiveRecord::Migration
  def change
    create_table :cases do |t|
      t.string :title
      t.text :description
      t.integer :amount_required
      t.timestamps null: false
    end
  end
end
