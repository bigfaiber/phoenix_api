class OpinionsController < ApplicationController
  before_action :set_opinion, only: [:update, :destroy]
  before_action :authenticate_admin!, only: [:create,:update,:destroy]

  def index
    @opinions = Opinion.load(page: params[:page] || 1, per_page: params[:per_page] || 10).by_client(client: params[:client_id])
    render json: @opinions, meta: pagination_dict(@opinions), each_serializer: OpinionSerializer, status: :ok
  end

  def create
    @opinion = Opinion.new(opinion_params)
    @opinion.client_id = params[:client_id]
    if @opinion.save
      render json: @opinion, serializer: OpinionSerializer, status: :created
    else
      @object = @client
      error_render
    end
  end

  def update
    if @opinion.update(opinion_params)
      render json: @opinion, serializer: OpinionSerializer, status: :ok
    else
      render json: @opinion.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @opinion
      @opinion.destroy
      head :ok
    else
      error_not_found
    end
  end

  private
  def set_opinion
    @opinion = Opinion.by_id(params[:id])
  end

  def opinion_params
    params.require(:opinion).permit(:opinion, :opinion_status)
  end
end
