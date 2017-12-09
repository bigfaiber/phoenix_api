class ClientsController < ApplicationController
  before_action :authenticate_admin!, only: [:destroy]
  before_action :authenticate_admin_or_client!, only: [:update]
  before_action :set_client, only: [:show,:update,:destroy,:show]

  def index
    @clients = Client.load(page: params[:page], per_page: params[:per_page])
    render json: @clients, each_serializer: ClientSerializer, status: :ok
  end

  def show
    if @client
      render json: @client, serializer: ClientSerializer, status: :ok
    else
      error_not_found
    end
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      command = AuthenticateCommand.call(params[:client][:email],params[:client][:password],@client.class.name)
      @current_client = @client
      @token = command.result
      ClientMailer.welcome(@client).deliver_later
      render json: @client, serializer: ClientSerializer, status: :created
    else
      @object = @client
      error_render
    end
  end

  def update
    if @client.update(client_params)
      render json: @client, serializer: ClientSerializer, status: :ok
    else
      @object = @client
      error_render
    end
  end

  def destroy
    @client.destroy!
    head :no_content
  end

  private
  def client_params
    params.require(:client).permit(:name,:lastname,:identification,:phone,:address,:birthday,:email,:city,:password,:password_confirmation)
  end
  def set_client
    @client = Client.by_id(params[:id])
  end
end
