class ProjectsController < ApplicationController
  before_action :authenticate_client!, only: [:create,:receipt,:clients]
  before_action :authenticate_admin_or_client!, only: [:update,:account]
  before_action :authenticate_admin!, only: [:destroy,:rate,:approve,:match,:search]
  before_action :authenticate_investor!, only: [:like,:investors]
  before_action :set_project, only: [:generate_table,:receipt,:update,:destroy,:rate,:account,:show,:approve, :like,:match]
  before_action :authenticate_admin_or_client_investor!,only: [:generate_table]

  def index
    @projects = Project.load(page: params[:page],per_page: params[:per_page])
    if params.has_key?(:price_start) && params.has_key?(:price_end)
      @projects = @projects.by_price(price_start: params[:price_start],price_end: params[:price_end])
    end
    if params.has_key?(:interest_start) && params.has_key?(:interest_end)
      @projects = @projects.by_interest(interest_start: params[:interest_start],interest_end: params[:interest_end])
    end
    if params.has_key?(:time_start) && params.has_key?(:time_end)
      @projects = @projects.by_time(time_start: params[:time_start],time_end: params[:time_end])
    end
    @projects = @projects.include_investor.include_account.include_client.include_receipts
    render json: @projects,meta: pagination_dict(@projects), each_serializer: ProjectSerializer, status: :ok
  end

  def clients
    @projects = Project.load(page: params[:page],per_page: params[:per_page]).by_client(id: @current_client.id)
    @projects = @projects.include_investor.include_account.include_client.include_receipts
    render json: @projects,meta: pagination_dict(@projects), each_serializer: ProjectSerializer, status: :ok
  end

  def investors
    @projects = Project.load(page: params[:page],per_page: params[:per_page]).by_investor(id: @current_investor.id)
    @projects = @projects.include_investor.include_account.include_client.include_receipts
    render json: @projects,meta: pagination_dict(@projects), each_serializer: ProjectSerializer, status: :ok
  end

  def search
    if params.has_key?(:client)
      @projects = Project.load(page: params[:page],per_page: params[:per_page]).by_client(id: params[:client])
      @projects = @projects.include_investor.include_account.include_client.include_receipts
      render json: @projects,meta: pagination_dict(@projects), each_serializer: ProjectSerializer, status: :ok
    elsif params.has_key?(:investors)
      @projects = Project.load(page: params[:page],per_page: params[:per_page]).by_investor(id: params[:investor])
      @projects = @projects.include_investor.include_account.include_client.include_receipts
      render json: @projects,meta: pagination_dict(@projects), each_serializer: ProjectSerializer, status: :ok
    else
      render json: {
        data: {
          errors: ["The key client or investor is required"]
        }
      }, status: 500
    end
  end

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

  def approve
    @project.approved = true
    @project.save
    ClientMailer.project_approved(@project.client.email).deliver_later
    head :ok
  end

  def like
    if @project
      if @project.approved
        Match.new(project_id: @project.id,investor_id: @current_investor.id).save
        head :ok
      else
        render json: {
          data:{
            errors: ["The project hasn't been approved by the admin"]
          }
        }, status: 500
      end
    else
      error_not_found
    end
  end

  def match
    if @project
      @investor = Investor.by_id(params[:investor_id])
      if @investor
        @investor.new_investor = false
        @investor.save
        @client = @project.client
        @client.new_client = false
        @client.save
        m = Match.by_project_and_investor(@project.id,@investor.id)
        if m
          m.approved = true
          m.save
          @project.investor_id = @investor.id
          @project.save
          ClientMailer.investor_match(@investor.email).deliver_later
          ClientMailer.clinet_match(@client.email).deliver_later
          Match.delete_not_approved(@project.id)
          head :ok
        else
          error_not_found
        end
      else
        error_not_found
      end
    else
      error_not_found
    end
  end

  def account
    if @project
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
    else
      error_not_found
    end

  end

  def receipt
    if @project
      if @current_client.id == @project.client.id
        if Project.add_receipt(@project.id,receipt_params)
          head :ok
        else
          render json: {
            data: {
              errors: ["We can't add the receipt"]
            }
          }, status: 500
        end
      else
        render json: {
          data: {
            errors: ["This project doesn't belongs you"]
          }
        }, status: 500
      end
    else
      error_not_found
    end
    head :ok
  end

  def generate_table
    if @project
      if @current_admin
        pdf = AmortizationPdf.new(@project)
        send_data pdf.render, filename: 'tabla_amortizacion.pdf', type: 'application/pdf'
      elsif (@current_client && @project.client && @project.client.id == @current_client.id) || (@current_investor && @project.investor && @project.investor.id == @current_investor.id)
        pdf = AmortizationPdf.new(@project)
        send_data pdf.render, filename: 'tabla_amortizacion.pdf', type: 'application/pdf'
      else
        render json: {
          data: {
            errors: ["You are not allowed to download this table"]
          }
        }, status: :ok
      end
    else
      error_not_found
    end
  end


  private
  def set_project
    @project = Project.by_id(params[:id])
  end

  def project_params
    params.require(:project).permit(:dream,:description,:money,:monthly_payment,:warranty,:month)
  end

  def receipt_params
    params.require(:receipt).permit(:month,:year,:receipt)
  end

  def account_params
    params.require(:bank).permit(:bank,:account_type,:account_number)
  end
end