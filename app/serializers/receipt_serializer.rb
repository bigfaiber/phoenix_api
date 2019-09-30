class ReceiptSerializer < ActiveModel::Serializer
  attributes :id,:year,:month,:day,:receipt,:is_grade,:grade,:delay,:days_in_arrears
end
