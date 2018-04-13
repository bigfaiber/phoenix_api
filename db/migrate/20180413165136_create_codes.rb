class CreateCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :codes do |t|
      t.string :code

      t.timestamps
    end
    Code.new(code: 'PRY0001').save
  end
end
