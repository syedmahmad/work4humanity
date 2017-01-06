class AddConfirmableAttributes < ActiveRecord::Migration
  def change
  	add_column :users, :confirmation_token, :string unless User.column_names.include? 'confirmation_token'
  	add_column :users, :confirmed_at, :datetime unless User.column_names.include? 'confirmed_at'
  	add_column :users, :confirmation_sent_at, :datetime unless User.column_names.include? 'confirmation_sent_at'
  	add_column :users, :unconfirmed_email, :string unless User.column_names.include? 'unconfirmed_email'
  end
end
