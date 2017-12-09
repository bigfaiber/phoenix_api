class Project < ApplicationRecord
  belongs_to :investor, optional: true
  belongs_to :account, optional: true
  has_many :receipts
  has_many :matches
  has_many :investors, through: :matches

  scope :include_investor, -> { includes(:investor) }
  scope :include_account, -> { includes(:account )}
  scope :include_receipts, -> { includes(:receipts )}
  scope :by_investor, -> (id:) { where(investor_id: id) }
  scope :by_account, -> (id:) { where(account_id: id) }


  validates_presence_of :dream, :description,:money,:monthly_payment,:month
  validates_numericality_of :money,:monthly_payment,:month, only_integer: true
  validates_numericality_of :month
  validate :validate_number

  def self.load(page:1 ,per_page: 10)
    paginate(page: page, per_page: per_page)
  end

  def self.by_id(id)
    find_by_id(id)
  end

  private
  def validate_number
    errors.add(:money, "can't be negative") if self.money && self.money < 0
    errors.add(:monthly_payment, "can't be negative") if self.monthly_payment && self.monthly_payment < 0
    errors.add(:month, "can't be negative") if self.month && self.month < 0
    errors.add(:interest_rate, "can't be negative") if self.interest_rate && self.interest_rate < 0
  end
end
