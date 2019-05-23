class UpdateMatchedProjects < ActiveRecord::Migration[5.1]
  def change
    Project.unscoped.find_each do |project|
      if project.investor_id != nil 
        say "Has an investor"
        project.matched = true
        project.save!
      end
    end
  end
end
