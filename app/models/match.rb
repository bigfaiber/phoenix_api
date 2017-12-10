class Match < ApplicationRecord
  belongs_to :project
  belongs_to :investor

  def self.by_project_and_investor(project,investor)
    where(investor_id:investor).where(project_id:project).first
  end

  def self.delete_not_approved(project)
    where(project_id: project).where(approved: false).destroy_all
  end
end
