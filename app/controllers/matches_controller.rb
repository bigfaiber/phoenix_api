class MatchesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @matches = Match.load(page: params[:page],per_page: params[:per_page]).by_approved(value: false)
    @matches = @matches.include_project.include_investor
    render json: @matches, meta: pagination_dict(@matches), each_serializer: MatchSerializer, include: ['investor', 'project', 'project.client', 'project.account'], status: :ok
  end

  def current_projects
    @matches = Match.load(page: params[:page],per_page: params[:per_page]).by_current.by_approved(value: true)
    @matches = @matches.include_project.include_investor
    render json: @matches, meta: pagination_dict(@matches), each_serializer: MatchSerializer, include: ['investor', 'project', 'project.client', 'project.account'], status: :ok
  end

end
