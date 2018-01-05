class AddInitialPaymentDateToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :initial_payment, :date, null: false
  end
end
