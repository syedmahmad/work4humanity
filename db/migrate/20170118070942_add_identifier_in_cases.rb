class AddIdentifierInCases < ActiveRecord::Migration
  def change
    add_column :cases, :identifier, :string
  end
end
