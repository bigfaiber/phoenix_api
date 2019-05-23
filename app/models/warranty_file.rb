class WarrantyFile < ApplicationRecord
  mount_uploader :document, DocumentUploader
  belongs_to :project

  class << self
    def by_project_id(id)
      where(project_id: id).first
    end
  end
end
