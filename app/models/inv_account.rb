class InvAccount < ApplicationRecord
  belongs_to :investor

  scope :by_investor, -> (id:) {where(investor_id: id)}

  enum account_type: {
    "Ahorros": 0,
    "Corriente": 1
  }

  validates_presence_of :bank,:account_number
  validates_inclusion_of :account_type, in: account_types.keys
  validates_numericality_of :account_number, only_integer: true
  validates_length_of :account_number, minimum: 6, maximum: 20

  def self.load(page: 1, per_page: 10)
    paginate(page: page, per_page: per_page)
  end

  def self.by_id(id)
    find_by_id(id)
  end
end
