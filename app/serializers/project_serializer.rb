class ProjectSerializer < ActiveModel::Serializer
  attributes :id,:initial_payment,:dream,:description,:money,:warranty,:monthly_payment,:month,:interest_rate,:approved
  has_many :receipts
  belongs_to :investor
  belongs_to :account
  belongs_to :client
end
