class RemoveNullConstraint < ActiveRecord::Migration[5.1]
  def change
    change_column :investors, :address, :string, :null => true
    change_column :investors, :city, :string, :null => true
    change_column :clients, :address, :string, :null => true
    change_column :clients, :city, :string, :null => true
  end
end
