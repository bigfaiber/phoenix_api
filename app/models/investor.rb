class Investor < ApplicationRecord
  has_secure_password
  mount_uploader :avatar, AvatarUploader

  has_one :payment
  has_many :documents, as: :imageable
  has_many :matches
  has_many :projects, through: :matches

  scope :include_payment, -> { includes(:payment) }
  scope :include_document, -> { includes(:documents) }

  enum education: [
    "Primaria": 0,
    "Secundaria": 1,
    "Profesional": 2,
    "Maestria": 3
  ]

  enum employment_status: [
    "Desempleado": 0,
    "Empleado": 1,
    "Independiente": 2
  ]

  validates_presence_of :name, :lastname, :identification, :phone, :address, :email, :city, :birthday
  validates_uniqueness_of :phone, :identification, :email
  validates_length_of :name,:lastname, minimum: 3
  validates_inclusion_of :education, in: educations.keys
  validates_length_of :password, minimum: 8, if: Proc.new {|a| a.new_record? }
  validates_inclusion_of :employment_status, in: employment_statuses.keys
  validate :valid_age
  validates_numericality_of :identification, only_integer: true
  validates_length_of :phone, minimum: 10, maximum: 15
  validates_length_of :identification, minimum: 8, maximum: 12

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
    errors.add(:birhtday,"you are under 18") if Date.today.year - self.birhtday.year < 18
    errors.add(:birthday,"you are under 18") if Date.today.year - self.birthday.year == 18 && Date.today.month > self.birthday.month
  end


end
