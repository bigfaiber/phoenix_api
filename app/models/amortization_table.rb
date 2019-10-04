class AmortizationTable < ApplicationRecord
  belongs_to :project
  mount_uploader :amortization_table, TableUploader

  def self.add_table(project:, table:)
    a = AmortizationTable.find_by_project_id(project)
    a.destroy if a
    AmortizationTable.create(amortization_table: table, project_id: project)
  end
end
