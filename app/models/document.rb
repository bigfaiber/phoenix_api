class Document < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  mount_uploader :document, DocumentUploader

  enum document_type: {
    "cc": 0,
    "renta": 1,
    "extractos": 2,
    "ingresos": 3
  }

  class << self
    def by_id(id)
      find_by_id(id)
    end
  end

  #validates_inclusion_of :document_type, in: document_types.keys

end
