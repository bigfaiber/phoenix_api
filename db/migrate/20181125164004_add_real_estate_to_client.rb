class AddRealEstateToClient < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :real_estate, :bool, default: false
  end
end
