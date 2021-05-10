class Project < ApplicationRecord
  #before_save :update_fee
  default_scope { order("matched DESC").order("projects.approved DESC") }
  before_update :update_month
  before_create :set_code

  belongs_to :investor, optional: true
  belongs_to :account, optional: true
  belongs_to :inv_account, optional: true
  belongs_to :client
  has_one :amortization_table, dependent: :destroy
  has_one :warranty_file, dependent: :destroy
  has_many :receipts, dependent: :destroy
  has_many :matches, dependent: :destroy
  has_many :investors, through: :matches
  has_many :tracings, dependent: :destroy

  delegate :full_name, to: :client

  scope :include_investor, -> { includes(:investor) }
  scope :include_account, -> { includes(:account )}
  scope :include_client, -> { includes(:client )}
  scope :include_receipts, -> { includes(:receipts )}
  scope :approved?, -> { where(approved: true) }
  scope :by_client, -> (id:) {where(client_id: id) }
  scope :by_investor, -> (id:) { where(investor_id: id).where(approved: true) }
  scope :by_account, -> (id:) { where(account_id: id) }
  scope :by_price, -> (price_start:,price_end:) { where(money: price_start..price_end) }
  scope :by_interest, -> (interest_start:,interest_end:) { where(interest_rate: interest_start..interest_end) }
  scope :by_time, -> (time_start:,time_end:) { where(month: time_start..time_end) }
  scope :by_finished, -> (value:) { where(finished:  value) }

  enum warranty: {
    "prenda": 0,
    "hipoteca": 1,
    "pagare": 2
  }

  # is not a field in front end :description,
  validates_presence_of :dream,:money,:monthly_payment,:month
  validates_numericality_of :money,:monthly_payment,:month, only_integer: true
  validates_numericality_of :month
  validate :validate_number
  validate :valid_date
  validates_inclusion_of :warranty, in: warranties.keys
  
  def self.active_projects
    approved?.size
  end
  
  def self.active_loans
    approved?.sum(:money)
  end

  def self.average_interest
    by_finished(value: false).where(matched: true).average(:interest_rate).to_f.round(2)
  end

  def self.load(page:1 ,per_page: 10)
    paginate(page: page, per_page: per_page)
  end

  def self.by_id(id)
    find_by_id(id)
  end

  def self.capital_distribution(investor)
    by_investor(id: investor).by_finished(value: false).pluck(:id,:money).map {|v| [Project.by_id(v[0]).full_name, v[1]]}
  end

  def self.add_receipt(project, params)
    r = Receipt.new(params)
    r.project_id = project
    r.save
  end

  def self.new_projects
    unscoped.joins(:client).select("clients.id, count(projects.id) AS total_projects").where(clients:{
      new_client: false
      }).where(clients: {
        step: 5
        }).where(projects: {
        new_project: true
        }).group("clients.id")
  end

  def self.has_project(client)
    if Project.where(client_id: client).where(new_project: true).count > 0
      true
    else
      false
    end
  end

  def change_level
    client = Client.by_id(self.client_id)
    time = self.receipts.count
    valid_payment = self.receipts.where(delay: 0).count
    case client.interest_level 
      when 0
        if time > 3
          if (valid_payment * 100.0)/time > 25 
            client.interest_level = 1
            client.save
          end 
        end 
      when 1
        if time > 6
          if (valid_payment * 100.0)/time > 50 
            client.interest_level = 2
            client.save
          elsif (valid_payment * 100.0)/time < 26
            client.interest_level = 0
            client.save
          end 
        end
      when 2
        if time > 9
          if (valid_payment * 100.0)/time > 75 
            client.interest_level = 3
            client.save
          elsif (valid_payment * 100.0)/time < 51 
            client.interest_level = 1
            client.save
          end 
        end
      when 3
        if time > 12
          if (valid_payment * 100.0)/time > 99 
            client.interest_level = 4
            client.save
          elsif (valid_payment * 100.0)/time < 76 
            client.interest_level = 2
            client.save
          end 
        end
      when 4
        if (valid_payment * 100.0)/time < 100
          client.interest_level = 3
          client.save
        end 
    end
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

  def self.by_code(code)
    find_by_code(code)
  end

  def self.add_warranty(project:, file:)
    w =  WarrantyFile.by_project_id(project)
    w.destroy if w
    temp = WarrantyFile.new(project_id: project, document: file)
    temp.save
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
