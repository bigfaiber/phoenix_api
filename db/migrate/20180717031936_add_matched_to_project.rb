class AddMatchedToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :matched, :boolean, default: false
    Project.all do |p|
      if(p.investor != nill)
        p.matched = true
        p.save
      end
    end
  end
end
