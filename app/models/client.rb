class Client < ApplicationRecord
  has_secure_password
  mount_uploader :avatar, AvatarUploader
  before_save :update_client_type

  has_many :vehicles, dependent: :destroy
  has_many :estates, dependent: :destroy
  has_many :documents, as: :imageable, dependent: :destroy
  has_many :projects, dependent: :destroy


  scope :new_clients, -> { where(new_client: true) }
  scope :valid_form, -> {where(step: 5)}
  scope :approved, -> {where("client_type = 0 OR client_type = 3")}
  scope :evaluation, -> {where("client_type = 2")}
  scope :unfit, -> {where("client_type = 1")}
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

  enum client_type: {
    'No calificado': 0,
    'No califica': 1,
    'Evaluacion': 2,
    'Califica': 3
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
  validates_inclusion_of :client_type, in: client_types.keys
  validates_numericality_of :identification, only_integer: true
  validates_length_of :phone, minimum: 10, maximum: 15
  validates_length_of :identification, minimum: 5, maximum: 12
  validates_numericality_of :rent_payment, only_integer: true
  validates_numericality_of :interest_level, greater_than_or_equal_to: 0, less_than_or_equal_to: 4
  validates_numericality_of :global, greater_than_or_equal_to: 0, less_than_or_equal_to: 100
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

  def self.by_identification(identification)
    find_by_identification(identification)
  end

  def self.upload_document(client,type,file)
    case type
    when "cc"
      Document.new(document_type: 0, document: file,imageable_id: client.id, imageable_type: client.class.name).save
    when "renta"
      Document.new(document_type: 1, document: file,imageable_id: client.id, imageable_type: client.class.name).save
    when "extractos"
      Document.new(document_type: 2, document: file,imageable_id: client.id, imageable_type: client.class.name).save
    when "ingresos"
      Document.new(document_type: 3, document: file,imageable_id: client.id, imageable_type: client.class.name).save
    end
  end

  def has_project
    Project.has_project(self.id)
  end

  def graph
    if self.global != 0
      index = 0
      values = {

      }
      values[index] = self.global
      index = index + 1
      Receipt.by_project(id: self.projects.ids).is_grade().group(:year,:month).average(:days_in_arrears).values.each do |v|
        values[index] = (values[index-1] + v).to_f
        index = index + 1 
      end
      return {
        data: {
          values: values
        }
      }
    else
      return {
        data: {
          values: {}
        }
      }
    end
  end

  def calculated_global
    calculated_global = self.global
    Receipt.by_project(id: self.projects.ids).is_grade().group(:year,:month).average(:days_in_arrears).values.each do |v|
      calculated_global = calculated_global + (v).to_f
    end
    calculated_global
  end

  def recommended_interest
    interes = {
      "0": {
        "60": "2.16",
        "61": "2.14",
        "62": "2.11",
        "63": "2.09",
        "64": "2.06",
        "65": "2.04",
        "66": "2.02",
        "67": "1.99",
        "68": "1.97",
        "69": "1.94",
        "70": "1.92",
        "71": "1.90",
        "72": "1.87",
        "73": "1.85",
        "74": "1.82",
        "75": "1.80",
        "76": "1.78",
        "77": "1.75",
        "78": "1.73",
        "79": "1.70",
        "80": "1.68",
        "81": "1.66",
        "82": "1.63",
        "83": "1.61",
        "84": "1.58",
        "85": "1.56",
        "86": "1.54",
        "87": "1.51",
        "88": "1.49",
        "89": "1.46",
        "90": "1.44",
        "91": "1.42",
        "92": "1.39",
        "93": "1.37",
        "94": "1.34",
        "95": "1.32",
        "96": "1.30",
        "97": "1.27",
        "98": "1.25",
        "99": "1.22",
        "100": "1.20"
      },
      "1": {
        "60": "2.05",
        "61": "2.03",
        "62": "2.01",
        "63": "1.98",
        "64": "1.96",
        "65": "1.94",
        "66": "1.92",
        "67": "1.89",
        "68": "1.87",
        "69": "1.85",
        "70": "1.82",
        "71": "1.80",
        "72": "1.78",
        "73": "1.76",
        "74": "1.73",
        "75": "1.71",
        "76": "1.69",
        "77": "1.66",
        "78": "1.64",
        "79": "1.62",
        "80": "1.60",
        "81": "1.57",
        "82": "1.55",
        "83": "1.53",
        "84": "1.50",
        "85": "1.48",
        "86": "1.46",
        "87": "1.44",
        "88": "1.41",
        "89": "1.39",
        "90": "1.37",
        "91": "1.35",
        "92": "1.32",
        "93": "1.30",
        "94": "1.28",
        "95": "1.25",
        "96": "1.23",
        "97": "1.21",
        "98": "1.19",
        "99": "1.16",
        "100": "1.14"
      },
      "2":{
        "60": "1.95",
        "61": "1.93",
        "62": "1.91",
        "63": "1.88",
        "64": "1.86",
        "65": "1.84",
        "66": "1.82",
        "67": "1.80",
        "68": "1.78",
        "69": "1.75",
        "70": "1.73",
        "71": "1.71",
        "72": "1.69",
        "73": "1.67",
        "74": "1.65",
        "75": "1.62",
        "76": "1.60",
        "77": "1.58",
        "78": "1.56",
        "79": "1.54",
        "80": "1.52",
        "81": "1.49",
        "82": "1.47",
        "83": "1.45",
        "84": "1.43",
        "85": "1.41",
        "86": "1.39",
        "87": "1.36",
        "88": "1.34",
        "89": "1.32",
        "90": "1.30",
        "91": "1.28",
        "92": "1.26",
        "93": "1.23",
        "94": "1.21",
        "95": "1.19",
        "96": "1.17",
        "97": "1.15",
        "98": "1.13",
        "99": "1.10",
        "100": "1.08"
      },
      "3":{
        "60": "1.85",
        "61": "1.83",
        "62": "1.81",
        "63": "1.79",
        "64": "1.77",
        "65": "1.75",
        "66": "1.73",
        "67": "1.71",
        "68": "1.69",
        "69": "1.67",
        "70": "1.65",
        "71": "1.63",
        "72": "1.61",
        "73": "1.58",
        "74": "1.56",
        "75": "1.54",
        "76": "1.52",
        "77": "1.50",
        "78": "1.48",
        "79": "1.46",
        "80": "1.44",
        "81": "1.42",
        "82": "1.40",
        "83": "1.38",
        "84": "1.36",
        "85": "1.34",
        "86": "1.32",
        "87": "1.30",
        "88": "1.28",
        "89": "1.26",
        "90": "1.23",
        "91": "1.21",
        "92": "1.19",
        "93": "1.17",
        "94": "1.15",
        "95": "1.13",
        "96": "1.11",
        "97": "1.09",
        "98": "1.07",
        "99": "1.05",
        "100": "1.03"
      },
      "4":{
        "60": "1.76",
        "61": "1.74",
        "62": "1.72",
        "63": "1.70",
        "64": "1.68",
        "65": "1.66",
        "66": "1.64",
        "67": "1.62",
        "68": "1.60",
        "69": "1.58",
        "70": "1.56",
        "71": "1.54",
        "72": "1.52",
        "73": "1.51",
        "74": "1.49",
        "75": "1.47",
        "76": "1.45",
        "77": "1.43",
        "78": "1.41",
        "79": "1.39",
        "80": "1.37",
        "81": "1.35",
        "82": "1.33",
        "83": "1.31",
        "84": "1.29",
        "85": "1.27",
        "86": "1.25",
        "87": "1.23",
        "88": "1.21",
        "89": "1.19",
        "90": "1.17",
        "91": "1.15",
        "92": "1.13",
        "93": "1.11",
        "94": "1.09",
        "95": "1.08",
        "96": "1.06",
        "97": "1.04",
        "98": "1.02",
        "99": "1.00",
        "100": "0.98"
      }
    }
    if self.global >= 60
      interes[self.interest_level.to_s.to_sym][self.global.to_s.to_sym]
    else
      "NO HAY INTERES RECOMENDADO"
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

  def update_client_type
    if self.global_changed?
      if self.global <= 50 
        self.client_type = 1
      elsif self.global > 50 && self.global < 60
        self.client_type = 2
      elsif self.global >= 60
        self.client_type = 3
      end
    end
  end
end
