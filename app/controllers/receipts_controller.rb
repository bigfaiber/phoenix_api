class ReceiptsController < ApplicationController
  before_action :authenticate_admin!, only: [:grade]
  before_action :set_receipt, only: [:grade]

  def grade
    if @receipt
      if Receipt.grade(id: params[:id], days: params[:receipt][:days])
        head :ok
      else
        error_grade
      end
    else
      error_not_found
    end
  end

  private
  def set_receipt
    @receipt = Receipt.by_id(params[:id])
  end

end
