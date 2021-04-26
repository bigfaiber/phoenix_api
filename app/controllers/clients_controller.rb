class ClientsController < ApplicationController
  before_action :authenticate_admin!, only: [:not_valid,:grade,:additional_data,:destroy,:new_clients,:old_clients]
  before_action :authenticate_client!, only: [:end_sign_up,:token,:verification,:avatar,:facebook_avatar,:goods,:documents,:new_verification_code]
  before_action -> { authorize_user(['Admin', 'Client']) }, only: [:show, :update, :index]
  before_action :set_client, only: [:graph, :grade, :additional_data, :update, :destroy]

  def index
    @clients = Client.load(page: params[:page], per_page: params[:per_page])
    @clients = @clients.include_vehicle.include_estate.include_document.include_project.include_pros.include_cons
    filter_clients
    render json: @clients, meta: pagination_dict(@clients), each_serializer: ClientSerializer, status: :ok
  end

  def new_clients
    @clients = Client.load(page: params[:page],per_page: params[:per_page]).new_clients.valid_form.approved
    @clients = @clients.include_vehicle.include_estate.include_document.include_project.include_pros.include_cons
    filter_clients
    render json: @clients, meta: pagination_dict_new_client(@clients), each_serializer: ClientSerializer, status: :ok
  end

  def old_clients
    @clients = Client.load(page: params[:page],per_page: params[:per_page]).old_clients.valid_form.approved
    @clients = @clients.include_vehicle.include_estate.include_document.include_project.include_pros.include_cons
    filter_clients
    render json: @clients, meta: pagination_dict_old_client(@clients), each_serializer: OldClientSerializer, status: :ok
  end

  def not_valid
    if params.has_key?(:client) && params[:client].has_key?(:type) && params[:client][:type].to_s == "unfit"
      @clients = Client.load(page: params[:page],per_page: params[:per_page]).valid_form.unfit
    elsif params.has_key?(:client) && params[:client].has_key?(:type) && params[:client][:type].to_s == "evaluation"
      @clients = Client.load(page: params[:page],per_page: params[:per_page]).valid_form.evaluation
    else
      @clients = Client.load(page: params[:page],per_page: params[:per_page]).valid_form.unfit
    end
    @clients = @clients.include_vehicle.include_estate.include_document.include_project.include_pros.include_cons
    render json: @clients, meta: pagination_dict(@clients), each_serializer: ClientSerializer, status: :ok
  end

  def show
    if load_client
      render json: @client, serializer: ClientSerializer, include: ['documents', 'vehicles', 'estates', 'projects.investor', 'projects.account', 'projects.investor.pros', 'projects.investor.cons', 'projects.investor.accounts', 'projects.investors.cons', 'projects.investors.pros', 'cons', 'pros'], status: :ok
    else
      error_not_found
    end
  end

  def token
    render json: @current_client, serializer: ClientSerializer, include: ['documents', 'vehicles', 'estates', 'projects.investor', 'projects.account', 'projects.investor.pros', 'projects.investor.cons', 'projects.inv_account', 'projects.investors.cons', 'projects.investors.pros', 'cons', 'pros'], status: :ok
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
        ClientMailer.new_password_confirmation(client,params[:password]).deliver_later
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

  # def create
  #   if !Investor.by_identification(params[:client][:identification])
  #     @client = Client.new(client_params)
  #     code = SecureRandom.uuid[0..7]
  #     @client.code = code
  #     if @client.valid?
  #       begin
  #         MessageSender.send_message(code,@client.phone)
  #       rescue Twilio::REST::TwilioError => error
  #         p error
  #         return render json: {
  #           data: {
  #             errors: ["We can't send the code"]
  #           }
  #         }, status: 500
  #       rescue Twilio::REST::RestError => error
  #         return render json: {
  #           data: {
  #             errors: ["We can't send the code"]
  #           }
  #         }, status: 500
  #       end
  #       @client.save
  #       command = AuthenticateCommand.call(params[:client][:email],params[:client][:password],@client.class.name)
  #       @current_client = @client
  #       @token = command.result
  #       @client = @client
  #       ClientMailer.code(@client).deliver_later
  #       render json: @client, serializer: ClientSerializer, status: :created
  #     else
  #       @object = @client
  #       error_render
  #     end
  #   else
  #     return render json: {
  #       data: {
  #         errors: ["We have an investor account with the same identification"]
  #       }
  #     }, status: 500
  #   end
  # end

  def create
    
    if !Investor.by_identification(params[:client][:identification])
      
      @client = Client.new(client_params)

      if @client.valid?
        # begin
        #   MessageSender.send_message(code,@client.phone)
        # rescue Twilio::REST::TwilioError => error
        #   p error
        #   return render json: {
        #     data: {
        #       errors: ["We can't send the code"]
        #     }
        #   }, status: 500
        # rescue Twilio::REST::RestError => error
        #   return render json: {
        #     data: {
        #       errors: ["We can't send the code"]
        #     }
        #   }, status: 500
        # end
        @client.save
        
        command = AuthenticateCommand.call(params[:client][:email], params[:client][:password], @client.class.name)
        
        @current_client = @client
        
        @token = command.result
        
        @client = @client
        
        render json: @client, serializer: ClientSerializer, status: :created
      else
        @object = @client
        error_render
      end
      
    else
      
      return render json: {
        data: {
          errors: ["We have an investor account with the same identification"]
        }
      }, status: 500
    end
    
  end

  def update
    if @client.update(client_params)
      render json: @client, serializer: ClientSerializer, include: ['documents', 'vehicles', 'estates', 'projects.investor', 'projects.account', 'pros', 'cons'], status: :ok
    else
      @object = @client
      error_render
    end
  end

  def graph
    if @client
      render json: @client.graph, status: :ok
    else
      error_not_found
    end
  end

  def grade
    if @client
      @client.global = params[:client][:global].to_i
      if @client.save
        head :ok
      else
        @object = @client
        error_render
      end
    else
      error_not_found
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
      ClientMailer.code(@current_client).deliver_later
    rescue Twilio::REST::TwilioError => error
      return render json: {
        data: {
          errors: ["We can't send the code"]
        }
      }, status: 500
    end
    head :ok
  end

  def goods
    Vehicle.where(client_id: @current_client.id).destroy_all
    Estate.where(client_id: @current_client.id).destroy_all
    params[:goods].each do |v|
      if v[:type] == "Vehicles"
        Vehicle.new(plate: v[:plate], price: v[:price],client_id: @current_client.id).save
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

  def facebook_avatar
    @current_client.remote_avatar_url = params[:avatar]
    if @current_client.save
      render json: @current_client, serializer: ClientSerializer, status: :ok
    else
      @object = @current_client
      error_render
    end
  end

  def documents
    Client.upload_document(params["file"].original_filename,@current_client,params[:type],params[:file])
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
      params.require(:client).permit(:name,:lastname,:identification,:phone,:address,:birthday,:email,:city,:rent,:rent_payment,:people,:education,:marital_status,:rent_tax,:employment_status,:job_position,:patrimony,:max_capacity,:current_debt,:income,:payment_capacity,:career,:technical_career,:household_type,:market_expenses,:transport_expenses,:public_service_expenses,:bank_obligations,:real_estate,:payments_in_arrears, :payments_in_arrears_value,:payments_in_arrears_time)
    end
    
    def client_params
      params.require(:client).permit(:step,:name,:lastname,:identification,:phone,:address,:birthday,:email,:city,:password,:password_confirmation,:rent,:rent_payment,:people,:education,:marital_status,:rent_tax,:employment_status,:terms_and_conditions,:career,:technical_career,:household_type,:market_expenses,:transport_expenses,:public_service_expenses,:bank_obligations,:real_estate,:payments_in_arrears, :payments_in_arrears_value,:payments_in_arrears_time)
    end
    
    def set_client
      @client = Client.by_id(params[:id])
    end
    
    def filter_clients
      if params.has_key?(:filter)
        p params[:filter]
        @clients = @clients.where("upper(name) like upper('%#{params[:filter]}%') or upper(lastname) like upper('%#{params[:filter]}%')")
      end
    end

    def load_client
      @client ||= client_scope.find_by_id(params[:id])
    end

    def client_scope
      Client.all
    end
end
