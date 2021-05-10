class Projects::AssignInvestorsController < ApplicationController
  before_action -> { authorize_user(['Investor']) }, only: [:update]
  before_action :set_project
  
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
    
    def project_params
      project_params = params[:project]
      project_params ? project_params.permit(:investor_id) : {}
    end
  
end
