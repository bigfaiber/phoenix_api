class Project < ApplicationRecord
  #before_save :update_fee
  before_update :update_month
  before_create :set_code

  belongs_to :investor, optional: true
  belongs_to :account, optional: true
  belongs_to :client
  has_one :amortization_table, dependent: :destroy
  has_many :receipts, dependent: :destroy
  has_many :matches, dependent: :destroy
  has_many :investors, through: :matches

  scope :include_investor, -> { includes(:investor) }
  scope :include_account, -> { includes(:account )}
  scope :include_client, -> { includes(:client )}
  scope :include_receipts, -> { includes(:receipts )}
  scope :approved?, -> {where(approved: true)}
  scope :by_client, -> (id:) {where(client_id: id) }
  scope :by_investor, -> (id:) { where(investor_id: id).where(approved: true) }
  scope :by_account, -> (id:) { where(account_id: id) }
  scope :by_price, -> (price_start:,price_end:) { where(money: price_start..price_end) }
  scope :by_interest, -> (interest_start:,interest_end:) { where(interest_rate: interest_start..interest_end) }
  scope :by_time, -> (time_start:,time_end:) { where(month: time_start..time_end) }
  scope :by_finished, -> (value: ) {where(finished:  value)}


  enum warranty: {
    "Prenda":0,
    "Hipoteca":1,
    "Pagare": 2
  }

  validates_presence_of :dream, :description,:money,:monthly_payment,:month
  validates_numericality_of :money,:monthly_payment,:month, only_integer: true
  validates_numericality_of :month
  validate :validate_number
  validate :valid_date
  validates_inclusion_of :warranty, in: warranties.keys


  def self.load(page:1 ,per_page: 10)
    paginate(page: page, per_page: per_page)
  end

  def self.by_id(id)
    find_by_id(id)
  end

  def self.add_receipt(project, params)
    r = Receipt.new(params)
    r.project_id = project
    r.save
  end

  def self.new_projects
    joins(:client).select("clients.id, count(projects.id) AS total_projects").where(clients:{
      new_client: false
      }).where(clients: {
        step: 5
        }).where(projects: {
        new_project: true
        }).group("clients.id")
  end

  private
  def set_code
    code = Code.first
    number = code.code[3..code.code.size].to_i
    number += 1
    self.code = code.code
    number_string = number.to_s
    if number_string.size == 1
      code_temp = "000#{number_string}"
    elsif number_string.size == 2
      code_temp = "00#{number_string}"
    elsif number_string.size == 3
      code_temp = "0#{number_string}"
    else
      code_temp = number_string
    end
    code.code = "PRY#{code_temp}"
    code.save
  end

  def update_month
    if self.changed.include?("interest_rate") || self.changed.include?("monthly_payment") || self.changed.include?("money")
      period = 0
      is_creating = true
      money_temp = self.money + 0.0
      while is_creating
        period = period + 1
        interest_temp = (self.interest_rate/100.0)*money_temp
        payment = self.monthly_payment - interest_temp
        if money_temp >= self.monthly_payment
          money_temp = money_temp - payment
        else
          money_temp = 0
        end

        if money_temp == 0
          is_creating = false
        end
      end
      self.month = period
    end
  end

  def validate_number
    errors.add(:money, "can't be negative") if self.money && self.money < 0
    errors.add(:monthly_payment, "can't be negative") if self.monthly_payment && self.monthly_payment < 0
    errors.add(:month, "can't be negative") if self.month && self.month < 0
    errors.add(:interest_rate, "can't be negative") if self.interest_rate && self.interest_rate < 0
  end

  def valid_date
    if self.approved_date && self.initial_payment && self.approved_date > self.initial_payment
      errors.add(:approved_date, "can't be higher than initial_payment")
      errors.add(:initial_payment, "can't be less than approved_date")
    end
  end
end
