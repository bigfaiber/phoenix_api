class InvestorSerializer < ActiveModel::Serializer
  attributes :id,:step,:name,:lastname,:identification,:phone,:address,:code_confirmation,:birthday,:email,:city,:employment_status,:education,:rent_tax,:avatar,:money_invest,:month,:monthly_payment,:profitability,:maximum
  attribute :created_at
  has_one :payment
  has_many :documents
  has_many :projects
  has_many :cons
  has_many :pros
  has_many :accounts

  def created_at
    (object.created_at - 5.hours).strftime("%Y, %B %d - %A %H:%M")
  end
end
