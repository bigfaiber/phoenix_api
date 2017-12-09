class ClientSerializer < ActiveModel::Serializer
  attributes :id,:name,:lastname,:identification,:phone,:address,:birthday,:email,:city,:rent,:rent_payment,:people,:education,:marital_status,:code_confirmation,:rent_tax,:employment_status,:avatar
  has_many :vehicles
  has_many :estates
  has_many :documents
end