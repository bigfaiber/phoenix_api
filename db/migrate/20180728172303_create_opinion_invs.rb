class CreateOpinionInvs < ActiveRecord::Migration[5.1]
  def change
    create_table :opinion_invs do |t|
      t.text :opinion, null: false
      t.integer :opinion_status, default: 0
      t.references :investor, foreign_key: true

      t.timestamps
    end
  end
end
