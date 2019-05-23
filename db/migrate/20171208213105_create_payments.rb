class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.integer :payment_type, null: false, default: 0
      t.string :name, null: false
      t.string :lastname, null: false
      t.string :card_number, null: false
      t.integer :card_type, null: false, default: 0
      t.string :ccv, null: false, default: ""
      t.string :month, null: false
      t.string :year, null: false
      t.belongs_to :investor, index: true

      t.timestamps
    end
  end
end
