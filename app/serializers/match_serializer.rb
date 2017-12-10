class MatchSerializer < ActiveModel::Serializer
  attributes :id, :approved
  belongs_to :project
  belongs_to :investor
end
