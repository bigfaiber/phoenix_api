class Document < ApplicationRecord
  belongs_to :imageable, polymorphic: true
end
