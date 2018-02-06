class AmortizationTable < ApplicationRecord
  belongs_to :project
  mount_uploader :table, TableUploader

  def self.add_table(project:, table:)
    a = find_by_project_id(project)
    a.destroy if a
    AmortizationTable.create(table: table, project_id: project)
  end
end
