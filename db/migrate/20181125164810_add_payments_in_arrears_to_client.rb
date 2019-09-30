class AddPaymentsInArrearsToClient < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :payments_in_arrears, :bool, default: false
    add_column :clients, :payments_in_arrears_value, :string, default: "0"
    add_column :clients, :payments_in_arrears_time, :string, default: "No ha tenido mora"
  end
end
