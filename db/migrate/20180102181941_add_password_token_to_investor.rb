class AddPasswordTokenToInvestor < ActiveRecord::Migration[5.1]
  def change
    add_column :investors, :token, :text, null: true
  end
end
