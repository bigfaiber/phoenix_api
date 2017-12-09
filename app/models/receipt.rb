class Receipt < ApplicationRecord
  belongs_to :project
  mount_uploader :receipt, ReceiptUploader

  scope :by_project, -> (id: ) { where(project_id: id) }

  validates_presence_of :month, :year
  validates_length_of :year, minimum: 4
  validates_numericality_of :year, only_integer: true

  def self.load(page: 1, per_page: 10)
    paginate(page: page, per_page: per_page)
  end

  def self.by_id(id)
    find_by_id(id)
  end

end
