class Profitability < ApplicationRecord
  default_scope { order("created_at ASC") }
  validates_presence_of :percentage, :name
  validates_uniqueness_of :name
  validates_numericality_of :percentage, greater_than_or_equal_to: 0, less_than_or_equal_to: 100

  class << self
    def by_id(id:)
      find_by_id(id)
    end

    def load(page: 1, per_page: 10)
      paginate(page: page, per_page: per_page)
    end
  end


end
