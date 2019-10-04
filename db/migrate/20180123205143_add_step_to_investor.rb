class AddStepToInvestor < ActiveRecord::Migration[5.1]
  def change
    add_column :investors, :step, :integer, default: 1
  end
end
