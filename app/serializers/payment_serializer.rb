class PaymentSerializer < ActiveModel::Serializer
  attributes :id,:payment_type,:name,:lastname,:card_number,:card_type,:ccv,:month,:year
end
