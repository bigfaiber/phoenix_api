class Account < ApplicationRecord

  enum account_type: {
    "Ahorros": 0,
    "Corriente": 1
  }

  validates_presence_of :bank,:account_number
  validates_inclusion_of :account_type, in: account_types.keys
  validates_numericality_of :account_number, only_integer: true
  validates_length_of :account_number, minimum: 6, maximum: 20

  def self.load(page: 1, per_page: 10)
    paginate(page: 1, per_page: 10)
  end

  def self.by_id(id)
    find_by_id(id)
  end
end
