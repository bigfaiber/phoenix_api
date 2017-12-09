class Document < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  mount_uploader :document, DocumentUploader

end
