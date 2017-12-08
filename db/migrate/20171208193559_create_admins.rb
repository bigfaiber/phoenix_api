class CreateAdmins < ActiveRecord::Migration[5.1]
  def change
    create_table :admins do |t|
      t.string :name, null: false
      t.string :lastname, null: false
      t.sting :email, null: false, unique: true
      t.text :password_digest, null: false

      t.timestamps
    end
  end
end
