class ClientsController < ApplicationController
  before_action :authenticate_admin!, only: [:destroy,:new_clients,:old_clients]
  before_action :authenticate_admin_or_client!, only: [:update]
  before_action :authenticate_client!, only: [:verification,:avatar,:goods,:documents]
  before_action :set_client, only: [:show,:update,:destroy,:show]

  def index
    @clients = Client.load(page: params[:page], per_page: params[:per_page])
    @clients = @clients.include_vehicle.include_estate.include_document.include_project
    render json: @clients, each_serializer: ClientSerializer, status: :ok
  end

  def new_clients
    @clients = Client.load(page: params[:page],per_page: params[:per_page]).new_clients
    @clients = @clients.include_vehicle.include_estate.include_document.include_project
    render json: @clients, each_serializer: ClientSerializer, status: :ok
  end

  def old_clients
    @clients = Client.load(page: params[:page],per_page: params[:per_page]).old_clients
    @clients = @clients.include_vehicle.include_estate.include_document.include_project
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
      begin
        code = SecureRandom.uuid[0..7]
        MessageSender.send_message(code,params[:client][:phone])
        @client.code = code
        @client.save
      rescue Twilio::REST::TwilioError => error
        p error.message
      end
      @client = @client
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

  def verification
    code = params[:code]
    if @current_client.code == code
      @current_client.code_confirmation = true
      @current_client.save
      head :ok
    else
      render json: {
        data:{
          errors: ['The codes are differents']
        }
      },status: 500
    end
  end

  def goods
    params[:goods].each do |v|
      if v[:type] == "Vehicles"
        Vehicle.new(price: v[:price],client_id: @current_client.id).save
      else
        Estate.new(price: v[:price],client_id: @current_client.id).save
      end
    end
    head :ok
  end

  def avatar
    if @current_client.update(avatar: params[:avatar])
      render json: @current_client, serializer: ClientSerializer, status: :ok
    else
      @object = @current_client
      error_render
    end
  end

  def documents
    Client.upload_document(@current_client,params[:type],params[:file])
    head :ok
  end

  private
  def client_params
    params.require(:client).permit(:name,:lastname,:identification,:phone,:address,:birthday,:email,:city,:password,:password_confirmation,:rent,:rent_payment,:people,:education,:marital_status,:rent_tax,:employment_status,:terms_and_conditions,:rating)
  end
  def set_client
    @client = Client.by_id(params[:id])
  end
end
