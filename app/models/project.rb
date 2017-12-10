class Project < ApplicationRecord
  before_save :update_fee
  before_update :update_fee

  belongs_to :investor, optional: true
  belongs_to :account, optional: true
  belongs_to :client
  has_many :receipts
  has_many :matches
  has_many :investors, through: :matches

  scope :include_investor, -> { includes(:investor) }
  scope :include_account, -> { includes(:account )}
  scope :include_client, -> { includes(:client )}
  scope :include_receipts, -> { includes(:receipts )}
  scope :by_investor, -> (id:) { where(investor_id: id) }
  scope :by_account, -> (id:) { where(account_id: id) }
  scope :by_price, -> (price_start:,price_end:) { where(money: price_start..price_end) }
  scope :by_interest, -> (interest_start:,interest_end:) { where(interest_rate: interest_start..interest_end) }
  scope :by_time, -> (time_start:,time_end:) { where(month: time_start..time_end) }




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

  def self.add_receipt(project, params)
    r = Recipt.new(params)
    r.project_id = project
    r.save
  end

  private
  def update_fee
    interest = self.interest_rate/100.0
    value = 1+interest
    partial_fee = self.money * ((interest * value**month)/((value**month) -1))
    partial_fee = (partial_fee / 5000.0).round
    partial_fee = partial_fee * 5000
    self.fee = partial_fee
  end
  def validate_number
    errors.add(:money, "can't be negative") if self.money && self.money < 0
    errors.add(:monthly_payment, "can't be negative") if self.monthly_payment && self.monthly_payment < 0
    errors.add(:month, "can't be negative") if self.month && self.month < 0
    errors.add(:interest_rate, "can't be negative") if self.interest_rate && self.interest_rate < 0
  end
end
