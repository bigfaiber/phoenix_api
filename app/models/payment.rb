class Payment < ApplicationRecord

  scope :by_investor, -> (id:) { where(investor_id: id) }

  enum payment_type: [
    "Tarjeta de credito": 0,
    "Tarjeta de debito": 1
  ]

  enum card_type: [
    "Credito": 0,
    "Ahorros": 1,
    "Corriente": 2
  ]

  validates_presence_of :name,:lastname,:card_number,:month,:year
  validates_inclusion_of :payment_type, in: payment_types.keys
  validates_inclusion_of :card_type, in: card_types.keys
  validates_length_of :cvv, minimum: 3, maximum: 3, if: :is_credit?
  validates_numericality_of :cvv, only_integer: true, if: :is_credit?
  validates_length_of :card_number, minimum: 8
  validates_numericality_of :card_number, only_integer: true
  validate :valid_card

  def self.load(page: 1, per_page: 10)
    paginate(page: page, per_page: per_page)
  end

  def self.by_id(id)
    find_by_id(id)
  end

  private
  def is_credit?
   payment_type == "Tarjeta de credito"
  end

  def valid_card
    errors.add(:year, 'is not valid') if self.year && self.year.to_i < Date.today.year
  end

end
