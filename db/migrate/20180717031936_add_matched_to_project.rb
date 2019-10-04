class AddMatchedToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :matched, :boolean, default: false
  end
end
