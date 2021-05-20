class Investors::ProjectsController < ApplicationController
  before_action -> { authorize_user(['Investor']) }, only: [:index, :update]
  before_action :set_project
  before_action :set_investor
  
  def index
    @projects = Project.load(page: params[:page],per_page: params[:per_page]).where(investor_id: @current_investor.id)
    
    @projects = @projects.include_investor.include_account.include_client.include_receipts
    
    render json: @projects,meta: pagination_dict(@projects), each_serializer: ProjectSerializer, status: :ok, include: ['client.cons', 'client.pros','inv_account','account','receipts','amortization_table','investor.pros','investor.cons','warranty_file']
  end
  
  def update
    @project.approved = true
    
    if @project.update(project_params)
      render json: @project, serializer: ProjectSerializer, status: :ok, include: ['client.cons', 'client.pros','inv_account','account','receipts','amortization_table','investor.pros','investor.cons','warranty_file']
    else
      @object = @project
      error_render
    end
  end
  
  private
    def set_project
      @project = Project.by_id(params[:id])
    end
  
    def set_investor
      @current_investor = Investor.by_id(params[:investor_id])
    end
    
    def project_params
      project_params = params[:project]
      project_params ? project_params.permit(:investor_id) : {}
    end
  
end
