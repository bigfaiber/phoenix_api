class Vehicle < ApplicationRecord
  belongs_to :client

  scope :by_clent, -> (id: ) { where(client_id: id) }

  validates_presence_of :price
  validates_numericality_of :price, only_integer: true
  validate :valid_price

  def self.load(page: 1, per_page: 10)
    paginate(page: page, per_page: per_page)
  end

  def self.by_id(id)
    find_by_id(id)
  end

  private
  def valid_price
    erros.add(:price, "can't be negative") if self.price && self.price.to_i < 0
  end
end
