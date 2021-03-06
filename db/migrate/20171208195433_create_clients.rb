class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :lastname, null: false
      t.string :identification, null: false, unique: true
      t.string :phone, null: false, unique: true
      t.string :address, null: false
      t.date :birthday, null: false
      t.string :email, null: false, unique: true
      t.string :city, null: false
      t.text :password_digest, null: false
      t.text :code, default: ""
      t.boolean :code_confirmation, default: false
      t.boolean :rent, default: false
      t.string :rent_payment, default: "0"
      t.integer :people, null: false, default: 0
      t.integer :education, null: false, default: 0
      t.integer :marital_status, null: false, default: 0
      t.boolean :rent_tax, default: false
      t.integer :employment_status, null: false, default: 0
      t.boolean :terms_and_conditions, default: false
      t.boolean :new_client, default: true
      t.float :rating, default: 0
      t.text :avatar

      t.timestamps
    end
  end
end
