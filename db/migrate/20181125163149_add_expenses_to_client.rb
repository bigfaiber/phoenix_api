class AddExpensesToClient < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :market_expenses, :string, default: "0"
    add_column :clients, :transport_expenses, :string, default: "0"
    add_column :clients, :public_service_expenses, :string, default: "0"
    add_column :clients, :bank_obligations, :string, default: "0"
  end
end
