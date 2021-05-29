class CreateFinancialStatus < ActiveRecord::Migration[5.1]
  def change
    create_table :financial_statuses do |t|
      t.json :available_equity
      t.json :available_income
      
      t.references :fstatus, polymorphic: true
      
      t.timestamps
    end
  end
end
