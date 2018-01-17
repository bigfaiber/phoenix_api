class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :dream, null: false
      t.text :description, null: false, default: ""
      t.integer :money, null: false
      t.integer :monthly_payment, null: false
      t.integer :month, null: false
      t.boolean :approved, default: false
      t.integer :warranty, null: false, default: 0
      t.float :interest_rate, null: false, default: 1.5
      t.belongs_to :investor, index: true
      t.belongs_to :account, index: true
      t.references :client, foreign_key: true


      t.timestamps
    end
  end
end
