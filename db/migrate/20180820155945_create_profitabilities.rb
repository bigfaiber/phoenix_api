class CreateProfitabilities < ActiveRecord::Migration[5.1]
  def change
    create_table :profitabilities do |t|
      t.string :name, null: false
      t.decimal :percentage, null: false, default: 0

      t.timestamps
    end
  end
end
