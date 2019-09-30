class CreateWarrantyFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :warranty_files do |t|
      t.text :document, null: false
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
