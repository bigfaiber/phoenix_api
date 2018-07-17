class CalculatedMatchForProjects < ActiveRecord::Migration[5.1]
  def change
    Project.all do |p|
      if(p.investor != nil)
        p.matched = true
        p.save
      end
    end
  end
end
