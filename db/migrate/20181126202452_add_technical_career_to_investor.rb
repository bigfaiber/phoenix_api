class AddTechnicalCareerToInvestor < ActiveRecord::Migration[5.1]
  def change
    add_column :investors, :technical_career, :string, default: ""
  end
end
