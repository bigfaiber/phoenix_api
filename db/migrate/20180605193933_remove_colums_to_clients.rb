class RemoveColumsToClients < ActiveRecord::Migration[5.1]
  def change
    remove_column :clients, :stability
    remove_column :clients, :nivel
  end
end
