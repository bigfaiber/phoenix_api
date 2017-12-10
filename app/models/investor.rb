class Investor < ApplicationRecord
  has_secure_password
  mount_uploader :avatar, AvatarUploader

  has_one :payment, dependent: :destroy
  has_many :documents, as: :imageable, dependent: :destroy
  has_many :matches, dependent: :destroy
  has_many :projects, -> { where("matches.approved = ?", true) } ,through: :matches

  scope :new_investors, -> { where(new_investor: true) }
  scope :old_investors, -> { where(new_investor: false) }
  scope :include_payment, -> { includes(:payment) }
  scope :include_document, -> { includes(:documents) }
  scope :include_project, -> { includes(:projects) }


  enum education: {
    "Primaria": 0,
    "Secundaria": 1,
    "Profesional": 2,
    "Maestria": 3
  }

  enum employment_status: {
    "Desempleado": 0,
    "Empleado": 1,
    "Independiente": 2
  }

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

  def self.create_payment(investor,params)
    if investor.payment
      investor.payment.destroy
    end
    p = Payment.new(params)
    p.investor_id = investor.id
    p.save
  end

  def self.upload_document(investor,type,file)
    case type
    when "cc"
      cc = investor.documents.cc.first
      if cc
        cc.destroy
      end
      Document.new(document_type: 0, document: file,imageable_id: investor.id, imageable_type: investor.class.name).save
    when "renta"
      renta = investor.documents.renta.first
      if renta
        renta.destroy
      end
      Document.new(document_type: 1, document: file,imageable_id: investor.id, imageable_type: investor.class.name).save
    when "extractos"
      extractos = investor.documents.extractos.first
      if extractos
        extractos.destroy
      end
      Document.new(document_type: 2, document: file,imageable_id: investor.id, imageable_type: investor.class.name).save
    when "ingresos"
      ingresos = investor.documents.ingresos.first
      if ingresos
        ingresos.destroy
      end
      Document.new(document_type: 3, document: file,imageable_id: investor.id, imageable_type: investor.class.name).save
    end
  end

  private
  def valid_age
    errors.add(:birthday,"you are under 18") if Date.today.year - self.birthday.year < 18
    errors.add(:birthday,"you are under 18") if Date.today.year - self.birthday.year == 18 && Date.today.month > self.birthday.month
  end


end
