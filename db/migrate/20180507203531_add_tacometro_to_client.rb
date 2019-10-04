class AddTacometroToClient < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :global, :integer, default: 0
    add_column :clients, :client_type, :integer, default: 0
    add_column :clients, :interest_level, :integer, default: 0
  end
end
