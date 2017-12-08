class CreateEstates < ActiveRecord::Migration[5.1]
  def change
    create_table :estates do |t|
      t.string :price, null: false
      t.references :client, foreign_key: true

      t.timestamps
    end
  end
end
