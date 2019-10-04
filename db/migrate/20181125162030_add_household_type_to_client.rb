class AddHouseholdTypeToClient < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :household_type, :integer, default: 0
  end
end
