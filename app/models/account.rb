class Account < ApplicationRecord

  enum account_types: [
    "Ahorros": 0,
    "Corriente": 1
  ]

  validates_presence_of :bank,:account_number
  validates_inclusion_of :account_type, in: account_types.keys
  validates_numericality_of :account_number, only_integer: true

  def load(page: 1, per_page: 10)
    paginate(page: 1, per_page: 10)
  end

  def self.by_id(id)
    find_by_id(id)
  end
end
