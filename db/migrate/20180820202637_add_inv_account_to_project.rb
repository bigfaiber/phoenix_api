class AddInvAccountToProject < ActiveRecord::Migration[5.1]
  def change
    add_reference :projects, :inv_account, foreign_key: true
  end
end
