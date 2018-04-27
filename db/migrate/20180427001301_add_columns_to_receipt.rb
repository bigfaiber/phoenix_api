class AddColumnsToReceipt < ActiveRecord::Migration[5.1]
  def change
    add_column :receipts, :is_grade, :boolean, default: false
    add_column :receipts, :delay, :integer, default: 0
    add_column :receipts, :grade, :decimal, default: 0
  end
end
