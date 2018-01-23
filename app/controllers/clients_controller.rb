class ClientsController < ApplicationController
  before_action :authenticate_admin!, only: [:additional_data,:destroy,:new_clients,:old_clients]
  before_action :authenticate_admin_or_client!, only: [:update]
  before_action :authenticate_client!, only: [:end_sign_up,:token,:verification,:avatar,:goods,:documents,:new_verification_code]
  before_action :set_client, only: [:additional_data,:show,:update,:destroy,:show]

  def index
    @clients = Client.load(page: params[:page], per_page: params[:per_page])
    @clients = @clients.include_vehicle.include_estate.include_document.include_project
    render json: @clients, meta: pagination_dict(@clients), each_serializer: ClientSerializer, status: :ok
  end

  def new_clients
    @clients = Client.load(page: params[:page],per_page: params[:per_page]).new_clients.valid_form
    @clients = @clients.include_vehicle.include_estate.include_document.include_project
    render json: @clients, meta: pagination_dict_new_client(@clients), each_serializer: ClientSerializer, status: :ok
  end

  def old_clients
    @clients = Client.load(page: params[:page],per_page: params[:per_page]).old_clients.valid_form
    @clients = @clients.include_vehicle.include_estate.include_document.include_project
    render json: @clients, meta: pagination_dict_old_client(@clients), each_serializer: ClientSerializer, status: :ok
  end

  def show
    if @client
      render json: @client, serializer: ClientSerializer, include: ['documents', 'vehicles', 'estates', 'projects.investor', 'projects.account'], status: :ok
    else
      error_not_found
    end
  end

  def token
    render json: @current_client, serializer: ClientSerializer, include: ['documents', 'vehicles', 'estates', 'projects.investor', 'projects.account'], status: :ok
  end

  def reset
    client = Client.by_email(params[:email])
    if client
      client.token = SecureRandom.uuid
      client.save
      ClientMailer.new_password(client, client.token).deliver_later
      render json: {data: {
        message: 'We have sent an email with the instructioins'
        }}, status: :ok
    else
      render json: {data: {
        errors: ["We don't have a client with that email"]
        }}, status: 500
    end
  end

  def new_password
    client = Client.by_email(params[:email])
    if client
      if client.token == params[:token]
        client.password = params[:password]
        client.password_confirmation =  params[:password_confirmation]
        client.token = nil
        client.save
        ClientMailer.new_password_confirmation(params[:email],params[:password]).deliver_later
        render json: {data: {
          message: 'We have sent an email the confirmation'
          }}, status: :ok
      else
        render json: {data: {
          errors: ["The tokens doesn't match"]
          }}, status: 500
      end
    else
      render json: {data: {
        errors: ["We don't have a client with that email"]
        }}, status: 500
    end
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      command = AuthenticateCommand.call(params[:client][:email],params[:client][:password],@client.class.name)
      @current_client = @client
      @token = command.result
      #ClientMailer.welcome(@client).deliver_later
      begin
        code = SecureRandom.uuid[0..7]
        MessageSender.send_message(code,params[:client][:phone])
        @client.code = code
        @client.save
      rescue Twilio::REST::TwilioError => error
        ender json: {
          data: {
            errors: ["We can't send the code"]
          }
        }, status: 500
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
      render json: @client, serializer: ClientSerializer, include: ['documents', 'vehicles', 'estates', 'projects.investor', 'projects.account'], status: :ok
    else
      @object = @client
      error_render
    end
  end

  def destroy
    @client.destroy!
    head :no_content
  end

  def end_sign_up
    ClientMailer.welcome(@current_client).deliver_later
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

  def new_verification_code
    begin
      code = SecureRandom.uuid[0..7]
      MessageSender.send_message(code,@current_client.phone)
      @current_client.code = code
      @current_client.save
    rescue Twilio::REST::TwilioError => error
      render json: {
        data: {
          errors: ["We can't send the code"]
        }
      }, status: 500
    end
    head :ok
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

  def additional_data
    if @client
      if @client.update(client_params_additional_data)
        render json: @client, serializer: ClientSerializer, include: ['documents', 'vehicles', 'estates', 'projects.investor', 'projects.account'], status: :ok
      else
        @object = @client
        error_render
      end
    else
      error_not_found
    end

  end

  private
  def client_params_additional_data
    params.require(:client).permit(:name,:lastname,:identification,:phone,:address,:birthday,:email,:city,:rent,:rent_payment,:people,:education,:marital_status,:rent_tax,:employment_status,:nivel,:stability,:job_position,:patrimony,:max_capacity,:current_debt,:income,:payment_capacity)
  end
  def client_params
    params.require(:client).permit(:step,:name,:lastname,:identification,:phone,:address,:birthday,:email,:city,:password,:password_confirmation,:rent,:rent_payment,:people,:education,:marital_status,:rent_tax,:employment_status,:terms_and_conditions,:rating)
  end
  def set_client
    @client = Client.by_id(params[:id])
  end
end
