class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string :bank, null: false
      t.integer :account_type, null: false, default: 0, limit: 8
      t.text :account_number, null: false

      t.timestamps
    end
  end
end
