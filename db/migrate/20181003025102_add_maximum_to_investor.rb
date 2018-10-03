class AddMaximumToInvestor < ActiveRecord::Migration[5.1]
  def change
    add_column :investors, :maximum, :string, default: '300000000'
  end
end
