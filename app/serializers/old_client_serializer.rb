class OldClientSerializer < ActiveModel::Serializer
  attributes :id,:step,:name,:lastname,:identification,:phone,:address,:birthday,:email,:city,:rent,:rent_payment,:people,:education,:marital_status,:code_confirmation,:rent_tax,:rating,:employment_status,:avatar, :max_capacity, :patrimony, :current_debt, :income, :payment_capacity,:stability,:nivel,:job_position,:interest_level,:global,:client_type
  attribute :recommended_interest
  attribute :has_project
  has_many :vehicles
  has_many :estates
  has_many :documents
  has_many :projects

  def recommended_interest
    object.recommended_interest
  end

  def has_project
    object.has_project
  end 
end
