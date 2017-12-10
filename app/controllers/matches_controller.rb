class MatchesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @matches = Match.load(page: params[:page],per_page: params[:per_page])
    @matches = @matches.include_project.include_investor
    render json: @matches, meta: pagination_dict(@matches), each_serializer: MatchSerializer, include: ['investor', 'project', 'project.client'], status: :ok
  end

end
