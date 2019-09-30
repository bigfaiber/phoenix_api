class AddNameToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :name, :text, default: ""
  end
end
