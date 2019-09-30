class AddDayToReceipt < ActiveRecord::Migration[5.1]
  def change
    add_column :receipts, :day, :integer
  end
end
