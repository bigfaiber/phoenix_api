class Clients::ProjectsController < ApplicationController
  before_action -> { authorize_user(['Client']) }, only: [:index]
  before_action :set_project
  before_action :set_client
  
  def index
    @projects = Project.load(page: params[:page],per_page: params[:per_page]).where(client_id: @current_client.id)
    
    @projects = @projects.include_investor.include_account.include_client.include_receipts
    
    render json: @projects,meta: pagination_dict(@projects), each_serializer: ProjectSerializer, status: :ok, include: ['client.cons', 'client.pros','inv_account','account','receipts','amortization_table','investor.pros','investor.cons','warranty_file']
  end
  
  private
    def set_project
      @project = Project.by_id(params[:id])
    end
  
    def set_client
      @current_client = Client.by_id(params[:client_id])
    end
end
