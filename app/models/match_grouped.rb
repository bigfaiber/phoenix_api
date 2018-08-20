class MatchGrouped
  alias :read_attribute_for_serialization :send
  attr_reader :project, :investors, :client

  def initialize(attributes)
    @project = attributes[:project]
    @investors = attributes[:investors]
    @client = attributes[:client]
  end

  def self.grouped
    values = Match.by_approved(value: false).group(:project_id).count(:id).map do |k,v|
      MatchGrouped.new({
        project: Project.by_id(k),
        client: Project.by_id(k).client,
        investors: Match.by_project(project: k).map { |m| m.investor }
      })
    end
    values
  end
end