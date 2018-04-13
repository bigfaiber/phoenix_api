class AddCodeToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :code, :string
    Project.all.each do |pr|
      code = Code.first
      number = code.code[3..code.code.size].to_i
      number += 1
      pr.code = code.code
      pr.save(validate: false)
      number_string = number.to_s
      if number_string.size == 1
        code_temp = "000#{number_string}"
      elsif number_string.size == 2
        code_temp = "00#{number_string}"
      elsif number_string.size == 3
        code_temp = "0#{number_string}"
      else
        code_temp = number_string
      end
      code.code = "PRY#{code_temp}"
      code.save
    end
  end
end
