class Match < ApplicationRecord
  belongs_to :project
  belongs_to :investor

  scope :include_project, -> { includes(project: :client) }
  scope :include_investor, -> { includes(:investor) }


  def self.by_project_and_investor(project,investor)
    where(investor_id:investor).where(project_id:project).first
  end

  def self.delete_not_approved(project)
    where(project_id: project).where(approved: false).destroy_all
  end

  def self.load(page: 1, per_page: 10)
    where(approved: false).paginate(page: page, per_page: per_page).order("crated_at DESC")
  end
end
