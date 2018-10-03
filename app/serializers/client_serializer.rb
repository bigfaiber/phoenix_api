class ClientSerializer < ActiveModel::Serializer
  attributes :id,:step,:name,:lastname,:identification,:phone,:address,:birthday,:email,:city,:rent,:rent_payment,:people,:education,:marital_status,:code_confirmation,:rent_tax,:rating,:employment_status,:avatar, :max_capacity, :patrimony, :current_debt, :income, :payment_capacity,:job_position,:interest_level,:client_type
  attribute :recommended_interest
  attribute :created_at
  attribute :global
  has_many :vehicles
  has_many :estates
  has_many :documents
  has_many :projects
  has_many :cons
  has_many :pros

  def recommended_interest
    object.recommended_interest
  end

  def global
    object.calculated_global
  end

  def created_at
    (object.created_at - 5.hours).strftime("%Y, %B %A, %H:%M")
  end
end
