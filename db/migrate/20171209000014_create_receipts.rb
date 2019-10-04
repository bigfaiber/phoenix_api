class CreateReceipts < ActiveRecord::Migration[5.1]
  def change
    create_table :receipts do |t|
      t.string :month, null: false
      t.integer :year, null: false
      t.text :receipt
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
