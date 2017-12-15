class CreateInvestors < ActiveRecord::Migration[5.1]
  def change
    create_table :investors do |t|
      t.string :name, null: false
      t.string :lastname, null: false
      t.string :identification, null: false, unique: true
      t.string :phone, null: false, unique: true
      t.string :address, null: false
      t.date :birthday, null: false
      t.string :email, null: false, unique: true
      t.string :city, null: false
      t.string :password_digest, null: false
      t.text :code, null: false, default:""
      t.boolean :code_confirmation, default: false
      t.integer :employment_status, null: false, default: 0
      t.integer :education, null: false, default: 0
      t.boolean :rent_tax, default: false
      t.boolean :terms_and_conditions, default: false
      t.text :avatar
      t.boolean :new_investor, default: true
      t.integer :money_invest, null: false
      t.integer :month, null: false, default: 1
      t.integer :monthly_payment, null: false
      t.integer :profitability, null: false 

      t.timestamps
    end
  end
end
