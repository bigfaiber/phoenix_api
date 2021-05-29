class AddToInvestor < ActiveRecord::Migration[5.1]
  def change
    add_column :investors, :global, :integer, default: 0
    add_column :investors, :client_type, :integer, default: 0
  end
end
