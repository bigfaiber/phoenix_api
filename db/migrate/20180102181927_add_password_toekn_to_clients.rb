class AddPasswordToeknToClients < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :token, :text, null: true
  end
end
