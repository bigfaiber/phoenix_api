class InvestorSerializer < ActiveModel::Serializer
  attributes :id,:step,:name,:lastname,:identification,:phone,:address,:code_confirmation,:birthday,:email,:city,:employment_status,:education,:rent_tax,:avatar,:money_invest,:month,:monthly_payment,:profitability
  has_one :payment
  has_many :documents
  has_many :projects
end
