class ProjectSerializer < ActiveModel::Serializer
  attributes :id,:dream,:description,:money,:warranty,:monthly_payment,:fee,:month,:interest_rate,:approve
  has_many :receipts
  belongs_to :investor
  belongs_to :account
  belongs_to :client
end
