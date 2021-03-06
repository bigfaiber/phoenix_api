class Investor < ApplicationRecord
  has_secure_password
  after_create :set_financial_status
  
  mount_uploader :avatar, AvatarUploader

  has_one :payment, dependent: :destroy
  has_many :accounts, class_name: 'InvAccount', dependent: :destroy
  has_many :documents, as: :imageable, dependent: :destroy
  has_one :financial_status, as: :fstatus, dependent: :destroy, class_name: 'FinancialStatus'
  has_many :matches, dependent: :destroy
  has_many :projects, -> {where(matches: {approved: true})} ,through: :matches
  has_many :pros, -> {where(opinion_status: 0)}, class_name: "OpinionInv", dependent: :destroy
  has_many :cons, -> {where(opinion_status: 1)}, class_name: "OpinionInv", dependent: :destroy

  scope :new_investors, -> { where(new_investor: true) }
  scope :valid_form, -> {where(step: 6)}
  scope :old_investors, -> { where(new_investor: false) }
  scope :include_payment, -> { includes(:payment) }
  scope :include_document, -> { includes(:documents) }
  scope :include_project, -> { includes(:projects).references(:projects) }


  enum education: {
    "Primaria": 0,
    "Bachiller": 1,
    "Profesional": 2,
    "Maestria": 3,
    "Tecnico/Tecnologo": 4
  }

  enum employment_status: {
    "Desempleado": 0,
    "Empleado": 1,
    "Independiente": 2,
    "Contratista": 3
  }
  
  enum client_type: {
    'no calificado': 0,
    'no califica': 1,
    'evaluacion': 2,
    'califica': 3
  }

  enum career: {
    'Administrador': 0,
    'Ingeniero': 1,
    'Medicina': 2,
    'Economia': 3,
    'Veterinaria': 4,
    'Contrabilidad': 5,
    'Mercadeo': 6,
    'Derecho': 7,
    'Arquitectura': 8,
    'Diseño': 9,
    'Otra': 10
  }

  validates_presence_of :name, :lastname, :identification, :phone, :email, :birthday
  validates_uniqueness_of :phone, :identification, :email
  validates_length_of :name,:lastname, minimum: 3
  validates_length_of :technical_career, within: 3..50, if: Proc.new { |a| a.education == "Tecnico/Tecnologo"}
  validates_inclusion_of :education, in: educations.keys
  validates_inclusion_of :career, in: careers.keys
  validates_length_of :password, minimum: 8, if: Proc.new {|a| a.new_record? }
  validates_inclusion_of :employment_status, in: employment_statuses.keys
  validates_numericality_of :global, greater_than_or_equal_to: 0, less_than_or_equal_to: 100
  validates_inclusion_of :client_type, in: client_types.keys
  validate :valid_age
  validates_numericality_of :identification, :maximum, only_integer: true
  validates_length_of :phone, minimum: 10, maximum: 15
  validates_length_of :identification, minimum: 8, maximum: 12
  validate :valid_step

  def self.load(page: 1, per_page: 10)
    paginate(page: page, per_page: per_page)
  end

  def self.by_id(id)
    find_by_id(id)
  end

  def self.by_identification(identification)
    find_by_identification(identification)
  end

  def self.by_email(email)
    find_by_email(email)
  end

  def self.create_payment(investor,params)
    if investor.payment
      investor.payment.destroy
    end
    p = Payment.new(params)
    p.investor_id = investor.id
    p.save
  end

  def self.upload_document(name,investor,type,file)
    case type
    when "cc"
      Document.new(name: name, document_type: 0, document: file,imageable_id: investor.id, imageable_type: investor.class.name).save
    when "renta"
      Document.new(name: name, document_type: 1, document: file,imageable_id: investor.id, imageable_type: investor.class.name).save
    when "extractos"
      Document.new(name: name, document_type: 2, document: file,imageable_id: investor.id, imageable_type: investor.class.name).save
    when "ingresos"
      Document.new(name: name, document_type: 3, document: file,imageable_id: investor.id, imageable_type: investor.class.name).save
    end
  end

  def debt
    ids = self.projects.where(finished: false).ids
    Tracing.total_debt(ids)
  end

  private
  
    def valid_age
      errors.add(:birthday,"you are under 18") if Date.today.year - self.birthday.year < 18
      errors.add(:birthday,"you are under 18") if Date.today.year - self.birthday.year == 18 && Date.today.month > self.birthday.month
    end

    def valid_step
      errors.add(:step,'is not valid') if self.step < 1 || self.step > 6
    end
    
    def set_financial_status
      initial_status = { asset: 0, liability: 0 }.to_json
      FinancialStatus.new(available_equity: initial_status, available_income: initial_status, fstatus_type: 'Investor', fstatus_id: id).save
    end
end
