class AdminsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin, only: [:show,:update,:destroy,:avatar]

  def index
    @admins = Admin.load(page: params[:page], per_page: params[:per_page])
    render json: @admins, each_serializer: AdminSerializer, meta: pagination_dict(@admins),status: :ok
  end

  def show
    if @admin
      render json: @admin, serializer: AdminSerializer
    else
      error_not_found
    end
  end

  def create
    @admin = Admin.new(admin_params)
    if @admin.save
      ClientMailer.admin_account(@admin.name,@admin.lastname,params[:admin][:password],@admin.email).deliver_later
      render json: @admin, serializer: AdminSerializer
    else
      @object = @investor
      error_render
    end
  end

  def update
    if @admin.update(admin_params)
      render json: @admin, serializer: AdminSerializer
    else
      @object = @investor
      error_render
    end
  end

  def destroy
    if @admin.id != @current_admin.id
      @admin.destroy
    end
    head :no_content
  end

  def avatar
    if @current_admin.update(avatar: params[:avatar])
      render json: @current_admin, serializer: AdminSerializer, status: :ok
    else
      @object = @current_admin
      error_render
    end
  end

  private
  def set_admin
    @admin = Admin.by_id(params[:id])
  end

  def admin_params
    params.require(:admin).permit(:name,:lastname,:email,:password,:password_confirmation)
  end
end
