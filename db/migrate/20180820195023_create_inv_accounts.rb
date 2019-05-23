class CreateInvAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :inv_accounts do |t|
      t.string :bank, null: false
      t.integer :account_type, null: false, default: 0
      t.text :account_number, null: false
      t.references :investor, foreign_key: true

      t.timestamps
    end
  end
end
