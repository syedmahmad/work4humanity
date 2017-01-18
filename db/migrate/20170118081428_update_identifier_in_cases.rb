class UpdateIdentifierInCases < ActiveRecord::Migration
  def change
    Case.all.each do |data|
      unless data.identifier.present?
        data.identifier = "case-#{data.id}"
        data.save
      end
    end
  end
end
