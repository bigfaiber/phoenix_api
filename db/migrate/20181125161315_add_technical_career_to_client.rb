class AddTechnicalCareerToClient < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :technical_career, :string, default: ""
  end
end
