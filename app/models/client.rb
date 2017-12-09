class Client < ApplicationRecord
  has_secure_password
  mount_uploader :avatar, AvatarUploader

  has_many :vehicles
  has_many :estates
  has_many :documents, as: :imageable


  scope :new_clients, -> { where(new: true)   }
  scope :include_vehicle, -> {includes(:vehicles) }
  scope :include_estate, -> {includes(:estates) }
  scope :include_document, -> {includes(:documents)}

  enum people: {
    "Ninguna": 0,
    "Una": 1,
    "Dos": 2,
    "tres": 3,
    "Mas de 3": 4
  }

  enum education: {
    "Primaria": 0,
    "Secundaria": 1,
    "Profesional": 2,
    "Maestria": 3
  }

  enum marital_status: {
    "Soltero": 0,
    "Casado": 1,
    "Divorciado": 2,
    "Viudo": 3
  }

  enum employment_status: {
    "Desempleado": 0,
    "Empleado": 1,
    "Independiente": 2
  }

  validates_presence_of :name,:lastname,:identification,:phone,:address,:birthday,:email,:city,:password
  validates_uniqueness_of :phone,:identification,:email
  validates_length_of :name,:lastname, minimum: 3
  validates_length_of :password, minimum: 8
  validate :valid_age
  validates_format_of :email, with: /\A[^@\s]+@[^@\s]+\z/
  validates_inclusion_of :people, in: people.keys
  validates_inclusion_of :education, in: educations.keys
  validates_inclusion_of :marital_status, in: marital_statuses.keys
  validates_inclusion_of :employment_status, in: employment_statuses.keys
  validates_numericality_of :phone,:identification, only_integer: true
  validates_length_of :phone, minimum: 10, maximum: 12
  validates_length_of :identification, minimum: 8, maximum: 12
  validates_numericality_of :rent_payment, only_integer: true

  def self.load(page: 1, per_page: 10)
    paginate(page: page, per_page: per_page)
  end

  def self.by_id(id)
    find_by_id(id)
  end

  def self.by_email(email)
    find_by_email(email)
  end

  private
  def valid_age
    errors.add(:birthday,"you are under 18") if Date.today.year - self.birthday.year < 18
    errors.add(:birthday,"you are under 18") if Date.today.year - self.birthday.year == 18 && Date.today.month > self.birthday.month
  end
end
