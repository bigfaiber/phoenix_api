class AddDaysInArrearsToReceipt < ActiveRecord::Migration[5.1]
  def up
    add_column :receipts, :days_in_arrears, :decimal, default: 0
    Receipt.all.each do |r| 
      if r.is_grade
        r.days_in_arrears = 0.5 - 0.25 * r.delay
        r.save
      end
    end
  end

  def down
    remove_column :receipts, :days_in_arrears
  end
end
