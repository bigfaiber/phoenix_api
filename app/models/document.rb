class Document < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  mount_uploader :document, DocumentUploader

  enum document_type: {
    "cc": 0,
    "renta": 1,
    "extractos": 2,
    "ingresos": 3
  }

  validates_inclusion_of :document_type, in: document_types.keys

end
