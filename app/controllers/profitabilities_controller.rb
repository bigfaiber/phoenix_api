class ProfitabilitiesController < ApplicationController
  before_action :set_profitability, only: [:show, :update, :destroy]
  before_action :authenticate_admin!, only: [:create,:update,:destroy]

  def index
    @profitabilities = Profitability.load(page: params[:page], per_page: params[:per_page])
    render json: @profitabilities,meta: pagination_dict(@profitabilities), each_serializer: ProfitabilitySerializer, status: :ok
  end

  def show
    if @profitability
      render json: @profitability
    else
      error_not_found
    end
  end

  def create
    @profitability = Profitability.new(profitability_params)
    if @profitability.save
      render json: @profitability, status: :created, location: @profitability
    else
      @object = @profitability
      error_render
    end
  end

  def update
    if @profitability.update(profitability_params)
      render json: @profitability
    else
      @object = @profitability
      error_render
    end
  end

  def destroy
    if @@profitability
      @profitability.destroy
      head :no_content
    else
      error_not_found
    end
  end

  private
  def set_profitability
    @profitability = Profitability.by_id(id: params[:id])
  end

  def profitability_params
    params.require(:profitability).permit(:name, :percentage)
  end
end
