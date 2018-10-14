class AddCareerToInvestor < ActiveRecord::Migration[5.1]
  def change
    add_column :investors, :career, :integer, default: 10
  end
end
