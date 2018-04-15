class ProjectSerializer < ActiveModel::Serializer
  attributes :id,:initial_payment,:approved_date,:dream,:description,:money,:warranty,:monthly_payment,:new_project,:month,:interest_rate,:code,:approved,:finished
  has_many :receipts
  belongs_to :investor
  belongs_to :account
  belongs_to :client
  has_one :amortization_table
  has_one :warranty_file
end
