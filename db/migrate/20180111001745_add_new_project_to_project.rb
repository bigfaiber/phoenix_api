class AddNewProjectToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :new_project, :boolean, default: true
  end
end
