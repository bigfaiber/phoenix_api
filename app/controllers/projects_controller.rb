class ProjectsController < ApplicationController
  before_action :authenticate_client!, only: [:create,:clients]
  before_action :authenticate_admin_or_client!, only: [:update,:account,:receipt]
  before_action :authenticate_admin!, only: [:finish,:add_warranty,:by_code,:add_table,:new_project,:destroy,:rate,:approve,:match,:search]
  before_action :authenticate_investor!, only: [:like,:investors]
  before_action :set_project, only: [:finish,:add_table,:new_project,:generate_table,:receipt,:update,:destroy,:rate,:account,:show,:approve, :like,:match]
  before_action :authenticate_admin_or_client_investor!,only: [:historical,:generate_table]

  def index
    @projects = Project.load(page: params[:page],per_page: params[:per_page]).by_finished(value: false)
    if params.has_key?(:price_start) && params.has_key?(:price_end)
      @projects = @projects.by_price(price_start: params[:price_start],price_end: params[:price_end])
    end
    if params.has_key?(:interest_start) && params.has_key?(:interest_end)
      @projects = @projects.by_interest(interest_start: params[:interest_start],interest_end: params[:interest_end])
    end
    if params.has_key?(:time_start) && params.has_key?(:time_end)
      @projects = @projects.by_time(time_start: params[:time_start],time_end: params[:time_end])
    end
    @projects = @projects.approved?.include_investor.include_account.include_client.include_receipts
    render json: @projects,meta: pagination_dict(@projects), each_serializer: ProjectSerializer, status: :ok, include: ['client.cons', 'client.pros','account','receipts','amortization_table','investor.pros','investor.cons','warranty_file']
  end

  def by_code
    @project = Project.by_code(params[:code])
    if @project
      render json: @project, status: :ok
    else
      error_not_found
    end
  end

  def historical
    @projects = Project.load(page: params[:page], per_page: params[:per_page]).by_finished(value: true)
    if @current_client
      @projects = @projects.by_client(id: @current_client.id)
    elsif @current_investor
      @projects = @projects.by_investor(id: @current_investor.id)
    end
    @projects = @projects.include_investor.include_account.include_client.include_receipts
    render json: @projects, meta: pagination_dict(@projects), each_serializer: ProjectSerializer, status: :ok, include: ['client.cons', 'client.pros','account','receipts','amortization_table','investor.cons','investor.pros','warranty_file']
  end

  def finish
    if @project
      @project.finished = true
      if @project.save
        @project.change_level
        head :ok
      else
        @object = @project
        error_render
      end
    else
      error_not_found
    end
  end

  def add_warranty
    if Project.add_warranty(project: params[:id], file: params[:file])
      head :ok
    else
      error_warranty
    end
  end

  def clients
    @projects = Project.load(page: params[:page],per_page: params[:per_page]).by_client(id: @current_client.id).by_finished(value: false)
    @projects = @projects.include_investor.include_account.include_client.include_receipts
    render json: @projects,meta: pagination_dict(@projects), each_serializer: ProjectSerializer, status: :ok, include: ['client.cons', 'client.pros','account','receipts','amortization_table','investor.pros','investor.cons','warranty_file']
  end

  def investors
    @projects = Project.load(page: params[:page],per_page: params[:per_page]).by_investor(id: @current_investor.id).by_finished(value: false)
    @projects = @projects.include_investor.include_account.include_client.include_receipts
    render json: @projects,meta: pagination_dict(@projects), each_serializer: ProjectSerializer, status: :ok, include: ['client.cons', 'client.pros','account','receipts','amortization_table','investor.pros','investor.cons','warranty_file']
  end

  def search
    if params.has_key?(:client)
      @projects = Project.load(page: params[:page],per_page: params[:per_page]).by_client(id: params[:client])
      @projects = @projects.include_investor.include_account.include_client.include_receipts
      render json: @projects,meta: pagination_dict(@projects), each_serializer: ProjectSerializer, status: :ok, include: ['client.cons', 'client.pros','account','receipts','amortization_table','investor.pros','investor.cons','warranty_file']
    elsif params.has_key?(:investors)
      @projects = Project.load(page: params[:page],per_page: params[:per_page]).by_investor(id: params[:investor])
      @projects = @projects.include_investor.include_account.include_client.include_receipts
      render json: @projects,meta: pagination_dict(@projects), each_serializer: ProjectSerializer, status: :ok, include: ['client.cons', 'client.pros','account','receipts','amortization_table','investor.pros','investor.cons','warranty_file']
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
      render json: @project, serializer: ProjectSerializer, include: ['client.cons', 'client.pros','account','receipts','amortization_table','investor.pros','investor.cons','warranty_file']
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
    ClientMailer.project_approved(@project.client).deliver_later
    head :ok
  end

  def like
    if @project
      if @project.approved
        unless Match.by_project_and_investor(@project.id,@current_investor.id)
          Match.new(project_id: @project.id,investor_id: @current_investor.id).save
          ClientMailer.client_like(@project.client).deliver_later
        end
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
          @project.matched = true
          @project.save
          ClientMailer.investor_match(@investor).deliver_later
          ClientMailer.clinet_match(@client).deliver_later
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

  def new_project
    if @project
      @project.new_project = false
      @project.save
      head :ok
    else
      error_not_found
    end
  end

  def receipt
    if @project
      if (@current_client && @current_client.id == @project.client.id) || @current_admin
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
  end

  def generate_table
    if @project
      if @current_admin 
        pdf = AmortizationPdf.new(@project)
        send_data Base64.encode64(pdf.render),
        filename: "table.pdf",
        type: 'application/octet-stream',
        disposition: 'attachment'
      elsif (@current_client && @project.client && @project.client.id == @current_client.id) || (@current_investor && @project.investor && @project.investor.id == @current_investor.id)
        pdf = AmortizationPdf.new(@project)
        send_data Base64.encode64(pdf.render),
        filename: "table.pdf",
        type: 'application/octet-stream',
        disposition: 'attachment'
      else
        pdf = AmortizationPdf.new(@project)
        send_data Base64.encode64(pdf.render),
        filename: "table.pdf",
        type: 'application/octet-stream',
        disposition: 'attachment'
      end
    else
      error_not_found
    end
  end

  def add_table
    if @project
      if AmortizationTable.add_table(project: params[:id],table: params[:table])
        head :ok
      else
        render json: {
          data: {
            errors: ["We can't uploaded the table"]
          }
        }, status: 500
      end
    else
      render json: {
        data: {
          errors: ["We can't find any project"]
        }
      }, status: 404
    end
  end


  private
  def set_project
    @project = Project.by_id(params[:id])
  end

  def project_params
    params.require(:project).permit(:dream,:description,:money,:monthly_payment,:warranty,:month,:initial_payment,:approved_date)
  end

  def receipt_params
    params.require(:receipt).permit(:month,:year,:receipt,:day)
  end

  def account_params
    params.require(:bank).permit(:bank,:account_type,:account_number)
  end
end
