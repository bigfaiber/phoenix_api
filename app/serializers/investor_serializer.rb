class InvestorSerializer < ActiveModel::Serializer
  attributes :id,:step,:name,:lastname,:identification,:phone,:address,:code_confirmation,:birthday,:email,:city,:client_type,:employment_status,:education,:rent_tax,:avatar,:money_invest,:month,:monthly_payment,:profitability,:maximum,:career,:technical_career
  attribute :created_at
  attribute :debt
  attribute :full_name
  attribute :global
  has_one :payment
  has_many :documents
  has_many :projects
  has_many :cons
  has_many :pros
  has_many :accounts
  has_one :financial_status

  def created_at
    (object.created_at - 5.hours).strftime("%Y, %B %d - %A %H:%M")
  end

  def debt
    object.debt
  end
  
  def full_name
    "#{object.name} #{object.lastname}"
  end
end
