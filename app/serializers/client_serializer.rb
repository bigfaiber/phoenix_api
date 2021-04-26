class ClientSerializer < ActiveModel::Serializer
  attributes :id,:step,:name,:lastname,:identification,:phone,:address,:birthday,:email,:city,:rent,:rent_payment,:people,:education,:marital_status,:code_confirmation,:rent_tax,:rating,:employment_status,:avatar, :max_capacity, :patrimony, :current_debt, :income, :payment_capacity,:job_position,:interest_level,:client_type,:career,:technical_career,:household_type,:market_expenses,:transport_expenses,:public_service_expenses,:bank_obligations,:real_estate,:payments_in_arrears, :payments_in_arrears_value,:payments_in_arrears_time
  attribute :recommended_interest
  attribute :created_at
  attribute :global
  attribute :full_name
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
    (object.created_at - 5.hours).strftime("%Y, %B %d - %A %H:%M")
  end
  
  def full_name
    "#{object.name} #{object.lastname}"
  end
end
