class OpinionInvsController < ApplicationController
  before_action :set_opinion, only: [:update, :destroy]
  before_action :authenticate_admin!, only: [:create,:update,:destroy]

  def index
    @opinions = OpinionInv.load(page: params[:page] || 1, per_page: params[:per_page] || 10).by_investor(investor: params[:investor_id])
    render json: @opinions, meta: pagination_dict(@opinions), each_serializer: OpinionSerializer, status: :ok
  end

  def create
    @opinion = OpinionInv.new(opinion_params)
    @opinion.investor_id = params[:investor_id]
    if @opinion.save
      render json: @opinion, serializer: OpinionSerializer, status: :created
    else
      @object = @opinion
      error_render
    end
  end

  def update
    if @opinion
      if @opinion.update(opinion_params)
        render json: @opinion, serializer: OpinionSerializer, status: :ok
      else
        @object = @opinion
        error_render
      end
    else
      error_not_found
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
    @opinion = OpinionInv.by_id(params[:id])
  end

  def opinion_params
    params.require(:opinion).permit(:opinion, :opinion_status)
  end
end
