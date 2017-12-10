class CreateMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :matches do |t|
      t.references :project, foreign_key: true
      t.references :investor, foreign_key: true
      t.boolean :approved, default: false

      t.timestamps
    end
    add_index :matches, [:project_id,:investor_id], unique: true
  end
end
