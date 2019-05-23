class ChangeMonthInRecipt < ActiveRecord::Migration[5.1]
  def change
    change_column :receipts, :month,'integer USING CAST(month AS integer)', default: 1
  end
end
