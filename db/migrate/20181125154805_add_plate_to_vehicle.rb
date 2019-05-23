class AddPlateToVehicle < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :plate, :string, default: ""
  end
end
