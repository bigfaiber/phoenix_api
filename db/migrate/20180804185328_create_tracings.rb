class CreateTracings < ActiveRecord::Migration[5.1]
  def change
    create_table :tracings do |t|
      t.integer :year, null: false
      t.integer :month, null: false
      t.decimal :interest, null: false, scale: 2, precision: 1000
      t.decimal :debt, null: false, scale: 2, precision: 1000
      t.references :project, foreign_key: true

      t.timestamps
    end
    add_index :tracings, [:project_id, :year, :month], unique: true, name: 'tracing_index'
  end
end
