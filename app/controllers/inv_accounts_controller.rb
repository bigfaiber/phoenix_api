class InvAccountsController < ApplicationController
  before_action :authenticate_admin_or_investor!
  before_action :set_inv_account, only: [:show,:update]

  def index
    @inv_accounts = InvAccount.load(page: params[:page], per_page: params[:per_page])
    if @current_admin
      @inv_accounts = @inv_accounts.by_investor(id: params[:investor_id]) 
    elsif @current_investor
      @inv_accounts = @inv_accounts.by_investor(id: @current_investor.id) 
    end
    render json: @inv_accounts,meta: pagination_dict(@inv_accounts), each_serializer: InvAccountSerializer, status: :ok
  end

  def show
    if @inv_account
      render json: @inv_accounts
    else
      error_not_found
    end
  end

  def create
    @inv_account = InvAccount.new(inv_account_params)
    if @current_admin
      @inv_account.investor_id = params[:investor_id]
    elsif @current_investor
      @inv_account.investor_id = @current_investor.id
    end
    if @inv_account.save
      render json: @inv_account, serializer: InvAccountSerializer, status: :ok
    else
      @object = @inv_account
      error_render
    end
  end

  def update
    if @inv_account
      if @inv_account.update(inv_account_params)
        render json: @inv_account, serializer: InvAccountSerializer, status: :ok
      else
        @object = @inv_account
        error_render
      end
    else
      error_not_found
    end
  end

  private
  def set_inv_account
    @inv_account = InvAccount.by_id(params[:id])
  end
  def inv_account_params
    params.require(:bank).permit(:bank,:account_type,:account_number)
  end
end
