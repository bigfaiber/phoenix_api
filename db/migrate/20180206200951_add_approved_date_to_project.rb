class AddApprovedDateToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :approved_date, :date, null: true
  end
end
