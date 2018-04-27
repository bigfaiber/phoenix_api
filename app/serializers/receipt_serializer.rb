class ReceiptSerializer < ActiveModel::Serializer
  attributes :id,:year,:month,:day,:receipt,:is_grade,:grade,:delay
end
