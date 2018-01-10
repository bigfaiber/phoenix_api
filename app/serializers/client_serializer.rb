class ClientSerializer < ActiveModel::Serializer
  attributes :id,:name,:lastname,:identification,:phone,:address,:birthday,:email,:city,:rent,:rent_payment,:people,:education,:marital_status,:code_confirmation,:rent_tax,:rating,:employment_status,:avatar, :max_capacity, :patrimony, :current_debt, :income, :payment_capacity
  has_many :vehicles
  has_many :estates
  has_many :documents
  has_many :projects
end
