class CreateAmortizationTables < ActiveRecord::Migration[5.1]
  def change
    create_table :amortization_tables do |t|
      t.text :amortization_table
      t.belongs_to :project, foreign_key: true

      t.timestamps
    end
  end
end
