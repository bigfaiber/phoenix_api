class InvestorsController < ApplicationController
  before_action :set_investor, only: [:show,:update,:destroy]
  before_action :authenticate_admin_or_investor!, only: [:update]
  before_action :authenticate_admin!, only: [:destroy,:new_investors,:old_investors]
  before_action :authenticate_investor!, only: [:verification,:avatar,:payment,:documents,:new_verification_code]


  def index
    @investors = Investor.load(page: params[:page], per_page: params[:per_page])
    @investors = @investors.include_payment.include_document.include_project
    render json: @investors, meta: pagination_dict(@investors), each_serializer: InvestorSerializer, status: :ok
  end

  def new_investors
    @investors = Investor.load(page: params[:page],per_page: params[:per_page]).new_investors
    @investors = @investors.include_document.include_project.include_payment
    render json: @investors, meta: pagination_dict(@investors), each_serializer: InvestorSerializer, status: :ok
  end

  def old_investors
    @investors = Investor.load(page: params[:page],per_page: params[:per_page]).old_investors
    @investors = @investors.include_payment.include_document.include_project
    render json: @investors,meta: pagination_dict(@investors), each_serializer: InvestorSerializer, status: :ok
  end

  def show
    if @investor
      render json: @investor, serializer: InvestorSerializer
    else
      error_not_found
    end
  end

  def create
    @investor = Investor.new(investor_params)
    if @investor.save
      command = AuthenticateCommand.call(params[:investor][:email],params[:investor][:password],@investor.class.name)
      @current_investor = @investor
      @token = command.result
      ClientMailer.welcome(@investor).deliver_later
      begin
        code = SecureRandom.uuid[0..7]
        MessageSender.send_message(code,params[:investor][:phone])
        @investor.code = code
        @investor.save
      rescue Twilio::REST::TwilioError => error
        p error.message
      end
      render json: @investor, serializer: InvestorSerializer, status: :created
    else
      @object = @investor
      error_render
    end

  end

  def update
    if @investor.update(investor_params)
      render json: @investor, serializer: InvestorSerializer, status: :ok
    else
      @object = @investor
      error_render
    end
  end

  def destroy
    @investor.destroy
    head :no_content
  end

  def verification
    code = params[:code]
    if @current_investor.code == code
      @current_investor.code_confirmation = true
      @current_investor.save
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
      MessageSender.send_message(code,params[:client][:phone])
      @current_investor.code = code
      @current_investor.save
    rescue Twilio::REST::TwilioError => error
      render json: {
        data: {
          errors: ["We can't send the code"]
        }
      }, status: 500
    end
    head :ok
  end

  def avatar
    if @current_investor.update(avatar: params[:avatar])
      render json: @current_investor, serializer: InvestorSerializer, status: :ok
    else
      @object = @current_investor
      error_render
    end
  end

  def payment
    if Investor.create_payment(@current_investor,payment_params)
      head :ok
    else
      render json: {
        data: {
          errors: ["We can't create the payment"]
        }
      }, status: :ok
    end
  end

  def documents
    Investor.upload_document(@current_investor,params[:type],params[:file])
    head :ok
  end

  private
  def investor_params
    params.require(:investor).permit(:money_invest,:month,:monthly_payment,:profitability,:name,:lastname,:identification,:phone,:address,:birthday,:email,:city,:password,:password_confirmation,:employment_status,:education,:rent_tax,:terms_and_conditions)
  end

  def payment_params
    params.require(:payment).permit(:name,:lastname,:card_number,:card_type,:ccv,:month,:year)
  end

  def set_investor
    @investor = Investor.by_id(params[:id])
  end

end
