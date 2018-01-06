class Receipt < ApplicationRecord
  default_scope do
    order(year: :desc).order(month: :desc)
  end
  belongs_to :project
  mount_uploader :receipt, ReceiptUploader

  scope :by_project, -> (id: ) { where(project_id: id) }

  enum month: {
    "Enero": 1,
    "Febrero": 2,
    "Marzo": 3,
    "Abril": 4,
    "Mayo": 5,
    "Junio": 6,
    "Julio": 7,
    "Agosto": 8,
    "Septiembre": 9,
    "Octubre": 10,
    "Noviembre": 11,
    "Diciembre": 12
  }

  validates_presence_of :month, :year, :day
  validates_length_of :year, minimum: 4
  validates_numericality_of :year,:day, only_integer: true
  validates_inclusion_of :month, in: months.keys
  validate :valid_date
  validate :unique_payment_by_project

  def self.load(page: 1, per_page: 10)
    paginate(page: page, per_page: per_page)
  end

  def self.by_id(id)
    find_by_id(id)
  end

  def valid_date
    p = Project.by_id(self.project_id)
    r = p.receipts.count + 1
    if p && p.initial_payment
      date = p.initial_payment + r.month
      if date.year > self.year
        errors.add(:year, "can't be less than initial payment year")
      elsif date.year == self.year && date.month != Receipt.months[self.month]
        errors.add(:month, "can't be less than initial payment month")
      end
    end
  end

  def unique_payment_by_project
    if Receipt.where(project_id: self.project_id).where(year: self.year).where(month: self.month).first
      errors.add(:project_id, "you have uploaded an receipt with the same date for the project")
    end
  end

end
