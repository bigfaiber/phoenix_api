class AccountSerializer < ActiveModel::Serializer
  attributes :id, :bank, :account_number, :account_type
end
