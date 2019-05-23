class MatchGroupedSerializer < ActiveModel::Serializer
  type 'data'
  belongs_to :project, class_name: "Project"
  belongs_to :client, class_name: "Client"
  has_many :investors, class_name: "Investor"
end
