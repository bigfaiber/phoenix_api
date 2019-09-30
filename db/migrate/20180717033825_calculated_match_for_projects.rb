class CalculatedMatchForProjects < ActiveRecord::Migration[5.1]
  def change
    Project.find_each do |project|
      if project.investor_id != nil 
        project.matched = true
        project.save!
      end
    end
  end
end
