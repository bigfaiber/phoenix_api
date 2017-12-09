class ProjectsController < ApplicationController
  before_action :authenticate_client!, only: [:create]
  before_action :authenticate_admin_or_client!, only: [:update,:account]
  before_action :authenticate_admin!, only: [:destroy,:rate]
  before_action :set_project, only: [:update,:destroy,:rate,:account,:show]

  def show
    if @project
      render json: @project, serializer: ProjectSerializer
    else
      error_not_found
    end
  end

  def create
    @project = Project.new(project_params)
    @project.client_id = @current_client.id
    if @project.save
      render json: @project, serializer: ProjectSerializer, status: :ok
    else
      @object = @project
      error_render
    end
  end

  def update
    if @project.update(project_params)
      render json: @project, serializer: ProjectSerializer, status: :ok
    else
      @object = @project
      error_render
    end
  end

  def destroy
    @project.destroy
    head :no_content
  end

  def rate
    @project.interest_rate = params[:project][:rate]
    @project.save
    if @project.save
      render json: @project, serializer: ProjectSerializer, status: :ok
    else
      @object = @project
      error_render
    end
  end

  def account
    if (@current_client && @current_client.id == @project.client_id) || @current_admin
      if @project.account
        @project.account.destroy
      end
      @account = Account.new(account_params)
      if @account.save
        @project.account_id = @account.id
        @project.save
        render json: @project, serializer: ProjectSerializer, status: :ok
      else
        @object = @account
        error_render
      end
    else
      render json: {
        data: {
          errors: ["The client is not the owner of the project"]
        }
      }, status: 401
    end
  end


  private
  def set_project
    @project = Project.by_id(params[:id])
  end

  def project_params
    params.require(:project).permit(:dream,:description,:money,:monthly_payment,:warranty,:month)
  end

  def account_params
    params.require(:bank).permit(:bank,:account_type,:account_number)
  end
end
