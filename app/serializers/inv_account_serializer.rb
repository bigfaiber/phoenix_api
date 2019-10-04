class InvAccountSerializer < ActiveModel::Serializer
  attributes :id, :bank, :account_number, :account_type, :investor_id
end
