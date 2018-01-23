class Client < ApplicationRecord
  has_secure_password
  mount_uploader :avatar, AvatarUploader

  has_many :vehicles, dependent: :destroy
  has_many :estates, dependent: :destroy
  has_many :documents, as: :imageable, dependent: :destroy
  has_many :projects, dependent: :destroy


  scope :new_clients, -> { where(new_client: true) }
  scope :valid_form, -> {where(step: 5)}
  scope :old_clients, -> { where(new_client: false) }
  scope :include_vehicle, -> {includes(:vehicles) }
  scope :include_estate, -> {includes(:estates) }
  scope :include_document, -> {includes(:documents)}
  scope :include_project, -> {includes(:projects)}


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
    "Independiente": 2,
    "Contratista": 3
  }

  validates_presence_of :name,:lastname,:identification,:phone,:address,:birthday,:email,:city
  validates_uniqueness_of :phone,:identification,:email
  validates_length_of :name,:lastname, minimum: 3
  validate :valid_age
  validates_length_of :password, minimum: 8, if: Proc.new {|a| a.new_record? }
  validates_format_of :email, with: /\A[^@\s]+@[^@\s]+\z/
  validates_inclusion_of :people, in: people.keys
  validates_inclusion_of :education, in: educations.keys
  validates_inclusion_of :marital_status, in: marital_statuses.keys
  validates_inclusion_of :employment_status, in: employment_statuses.keys
  validates_numericality_of :identification, only_integer: true
  validates_length_of :phone, minimum: 10, maximum: 15
  validates_length_of :identification, minimum: 8, maximum: 12
  validates_numericality_of :rent_payment, only_integer: true
  validate :valid_rating
  validate :valid_step
  validates_numericality_of :max_capacity, :patrimony, :current_debt, :income, :payment_capacity, allow_nil: true, only_integer: true

  def self.load(page: 1, per_page: 10)
    paginate(page: page, per_page: per_page)
  end

  def self.by_id(id)
    find_by_id(id)
  end

  def self.by_email(email)
    find_by_email(email)
  end

  def self.upload_document(client,type,file)
    case type
    when "cc"
      cc = client.documents.cc.first
      if cc
        cc.destroy
      end
      Document.new(document_type: 0, document: file,imageable_id: client.id, imageable_type: client.class.name).save
    when "renta"
      renta = client.documents.renta.first
      if renta
        renta.destroy
      end
      Document.new(document_type: 1, document: file,imageable_id: client.id, imageable_type: client.class.name).save
    when "extractos"
      extractos = client.documents.extractos.first
      if extractos
        extractos.destroy
      end
      Document.new(document_type: 2, document: file,imageable_id: client.id, imageable_type: client.class.name).save
    when "ingresos"
      ingresos = client.documents.ingresos.first
      if ingresos
        ingresos.destroy
      end
      Document.new(document_type: 3, document: file,imageable_id: client.id, imageable_type: client.class.name).save
    end
  end

  private
  def valid_age
    errors.add(:birthday,"you are under 18") if self.birthday && Date.today.year - self.birthday.year < 18
    errors.add(:birthday,"you are under 18") if self.birthday && Date.today.year - self.birthday.year == 18 && Date.today.month > self.birthday.month
  end

  def valid_step
    errors.add(:step,'is not valid') if self.step < 1 || self.step > 5
  end

  def valid_rating
    errors.add(:rating,"is not valid") if self.rating && (self.rating < 0 || self.rating > 5)

  end
end
