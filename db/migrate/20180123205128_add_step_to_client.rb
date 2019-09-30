class AddStepToClient < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :step, :integer, default: 1
  end
end
