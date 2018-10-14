class AddCareerToClients < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :career, :integer, default: 10
  end
end
