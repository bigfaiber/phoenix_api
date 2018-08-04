class Tracing < ApplicationRecord
  belongs_to :project

  validates_presence_of :year,:month,:interest,:debt
  validates_numericality_of :interest,:debt, greater_than_or_equal_to: 0
  validate :valid_month
  validate :valid_year
  validates_uniqueness_of :project_id, scope: [:year, :month]
  
  class << self
    def by_year_month_and_project(year:, month:, project:)
      where(year: year).where(month: month).where(project_id: project).first
    end

    def by_id(id)
      find_by_id(id)
    end

    def load(page: 1, per_page: 10)
      paginate(page: page, per_page: per_page)
    end

    def debt_by_year_and_month(ids)
      where(project_id: ids).group(:year,:month).sum(:debt)
    end

    def interest_by_year_and_month(ids)
      where(project_id: ids).group(:year,:month).sum(:interest)
    end

  end

  private
  def valid_year
    errors.add(:year, 'is not valid, it can be greater than the current year') if self.year && self.year > Date.today.year
  end
  def valid_month
    errors.add(:month, 'is not valid') if self.month && (self.month < 0 || self.month > 12)
  end

end
