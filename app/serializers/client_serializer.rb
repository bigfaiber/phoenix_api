class ClientSerializer < ActiveModel::Serializer
  attributes :id,:name,:lastname,:identification,:phone,:address,:birthday,:email,:city,:rent,:rent_payment,:people,:education,:marital_status,:rent_tax,:employment_status,:avatar
end
