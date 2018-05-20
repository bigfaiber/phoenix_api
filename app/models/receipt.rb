class Receipt < ApplicationRecord
  default_scope do
    order(year: :desc).order(month: :desc)
  end
  belongs_to :project
  mount_uploader :receipt, ReceiptUploader

  scope :by_project, -> (id: ) { where(project_id: id) }
  scope :is_grade, -> { where(is_grade: true) }

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
  validates_numericality_of :grade
  validates_numericality_of :year,:day,:delay, only_integer: true
  validates_inclusion_of :month, in: months.keys
  validate :unique_payment_by_project
  validate :valid_delay
  validate :valid_grade
  #validate :valid_date
  

  def self.load(page: 1, per_page: 10)
    paginate(page: page, per_page: per_page)
  end

  def self.by_id(id)
    find_by_id(id)
  end

  def self.grade(id:, days:)
    values = {
      0 => 5.0,
      1 => 4.5,
      2 => 4,
      3 => 3.5,
      4 => 3,
      5 => 2.5,
      6 => 2,
      7 => 1.5,
      8 => 1,
      9 => 0.5,
      10 => 0,
      11 => -0.5,
      12 => -1.0,
      13 => -1.5,
      14 => -2.0,
      15 => -2.5,
      16 => -3.0,
      17 => -3.5,
      18 => -4.0,
      19 => -4.5,
      20 => -5
    }
    r = find_by_id(id)
    if r
      r.is_grade = true
      r.delay = days
      r.grade = values[days.to_i]
      r.days_in_arrears = 0.5 - 0.25 * r.delay
      if r.save
        client = r.project.client.id
        projects = Project.by_client(id: client).ids
        receipts = Receipt.by_project(id: projects)
        count = 0
        sum = 0.0
        receipts.each do |receipt|
          if receipt.is_grade
            count += 1
            sum += receipt.grade
          end
        end
        if count != 0
          c = Client.by_id(client)
          c.rating = sum/count
          return c.save
        end
        return true
      else
        return false
      end
    end
  end

  private

  def valid_delay
    errors.add(:delay, "is not valid, the valid range is between zero and twenty") if delay < 0 || delay > 20
  end

  def valid_grade
    errors.add(:grade, "is not valid") if grade < -5.0 || grade > 5.0
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
    a = Receipt.where(project_id: self.project_id).where(year: self.year).where(month: self.month).first
    if a && a.id != self.id
      errors.add(:project_id, "you have uploaded an receipt with the same date for the project")
    end
  end

end
