class OpinionInv < ApplicationRecord
  belongs_to :investor

  enum opinion_status: {
    pros: 0,
    cons: 1
  }

  scope :by_investor, -> (investor: ) {where(investor_id: investor)}
  
  validates_presence_of :opinion
  validates_length_of :opinion, within: 5..200
  validates_inclusion_of :opinion_status, in: opinion_statuses.keys
  
  class << self
    def by_id(id)
      find_by_id(id)
    end
    def load(page: 1, per_page: 10)
      paginate(page: page, per_page: per_page)
    end
  end
end