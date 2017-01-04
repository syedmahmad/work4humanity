class AddHopitalCasesAssociation < ActiveRecord::Migration
  def change
    add_reference :cases, :hospital, index: true
  end
end
