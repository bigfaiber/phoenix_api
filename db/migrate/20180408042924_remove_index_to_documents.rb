class RemoveIndexToDocuments < ActiveRecord::Migration[5.1]
  def change
    remove_index :documents, name: 'document_index'
  end
end
