class FinancialStatusController < ApplicationController
  before_action -> { authorize_user(['Admin']) }, only: [:update]
  
  def update
    if ['Client', 'Investor'].include?(params[:user][:type])
      
      user = Kernel.const_get(params[:user][:type]).by_id(params[:id])
      
      if user.financial_status.update(available_equity: params[:user][:available_equity].to_json, available_income: params[:user][:available_income].to_json)
        user.update(client_type: params[:user][:client_type], global: params[:user][:calification])
        render json: user, include: ['documents', 'vehicles', 'estates', 'financial_status', 'projects.investor', 'projects.account', 'pros', 'cons'], status: :ok
      else
        @object = @user
        error_render
      end
      
    else
      
      return render json: {
        data: {
          errors: ["There is an error with the information provided"]
        }
      }, status: 500

    end
  end
  
end