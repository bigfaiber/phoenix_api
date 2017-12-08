class CreateDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :documents do |t|
      t.integer :document_type, null: false, default: 0
      t.text :document, null: false
      t.references :imageable, polymorphic: true

      t.timestamps
    end
    add_index [:document_type, :imageable_type, :imageable_id], unique: true
  end
end
