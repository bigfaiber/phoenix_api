class DocumentSerializer < ActiveModel::Serializer
  attributes :id, :document_type, :document, :name
end
