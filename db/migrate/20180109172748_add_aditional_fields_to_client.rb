class AddAditionalFieldsToClient < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :nivel, :string, null: true
    add_column :clients, :stability, :string, null: true
    add_column :clients, :job_position, :string, null: true
    add_column :clients, :patrimony, :string, null: true
    add_column :clients, :max_capacity, :string, null: true
    add_column :clients, :current_debt, :string, null: true
    add_column :clients, :income, :string, null: true
    add_column :clients, :payment_capacity, :string, null: true
  end
end
