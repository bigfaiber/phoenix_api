class InvestorsController < ApplicationController
  before_action :set_investor, only: [:show,:update,:destroy,:graphs,:maximum]
  before_action :authenticate_admin_or_investor!, only: [:update, :index, :show]
  before_action :authenticate_admin!, only: [:destroy,:new_investors,:old_investors,:maximum]
  before_action :authenticate_investor!, only: [:end_sign_up,:token,:verification,:avatar,:facebook_avatar,:payment,:documents,:new_verification_code]


  def index
    @investors = Investor.load(page: params[:page], per_page: params[:per_page])
    @investors = @investors.include_payment.include_document.include_project
    render json: @investors, meta: pagination_dict(@investors), each_serializer: InvestorSerializer, status: :ok
  end

  def new_investors
    @investors = Investor.load(page: params[:page],per_page: params[:per_page]).new_investors.valid_form
    @investors = @investors.include_document.include_project.include_payment
    render json: @investors, meta: pagination_dict(@investors), each_serializer: InvestorSerializer, status: :ok
  end

  def old_investors
    @investors = Investor.load(page: params[:page],per_page: params[:per_page]).old_investors.valid_form
    @investors = @investors.include_payment.include_document.include_project
    render json: @investors,meta: pagination_dict(@investors), each_serializer: InvestorSerializer, status: :ok
  end

  def show
    if @investor
      render json: @investor, serializer: InvestorSerializer, include: ['payment', 'documents', 'projects.client', 'projects.account','projects.inv_account'], status: :ok
    else
      error_not_found
    end
  end

  def maximum
    if @investor
      @investor.maximum = params[:investor][:maximun]
      if @investor.save
        head :ok
      else
        @object = @investor
        error_render
      end
    else
      error_not_found
    end
  end

  def token
    render json: @current_investor, serializer: InvestorSerializer, include: ['payment', 'documents', 'projects.client', 'projects.account','projects.inv_account'], status: :ok
  end

  def create
    if !Client.by_identification(params[:investor][:identification])
      @investor = Investor.new(investor_params)
      code = SecureRandom.uuid[0..7]
      @investor.code = code
      if @investor.valid?
        #ClientMailer.welcome(@investor).deliver_later
        begin
          MessageSender.send_message(code,@investor.phone)
        rescue Twilio::REST::TwilioError => error
          return render json: {
            data: {
              errors: ["We can't send the code"]
            }
          }, status: 500
        rescue Twilio::REST::RestError => error
          return render json: {
            data: {
              errors: ["We can't send the code"]
            }
          }, status: 500
        end
        @investor.save
        command = AuthenticateCommand.call(params[:investor][:email],params[:investor][:password],@investor.class.name)
        @current_investor = @investor
        @token = command.result
        ClientMailer.code(@investor).deliver_later
        render json: @investor, serializer: InvestorSerializer, status: :created
      else
        @object = @investor
        error_render
      end
    else
      return render json: {
        data: {
          errors: ["We have a client account with the same identification"]
        }
      }, status: 500
    end

  end

  def update
    if @investor.update(investor_params)
      render json: @investor, serializer: InvestorSerializer, include: ['payment', 'documents', 'projects.client', 'projects.account'], status: :ok
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
      MessageSender.send_message(code,@current_investor.phone)
      @current_investor.code = code
      @current_investor.save
      ClientMailer.code(@current_investor).deliver_later
    rescue Twilio::REST::TwilioError => error
      return render json: {
        data: {
          errors: ["We can't send the code"]
        }
      }, status: 500
    end
    head :ok
  end

  def end_sign_up
    ClientMailer.welcome(@current_investor).deliver_later
    head :no_content
  end

  def avatar
    if @current_investor.update(avatar: params[:avatar])
      render json: @current_investor, serializer: InvestorSerializer, status: :ok
    else
      @object = @current_investor
      error_render
    end
  end

  def facebook_avatar
    @current_investor.remote_avatar_url = params[:avatar]
    if @current_investor.save
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
    Investor.upload_document(params["file"].original_filename,@current_investor,params[:type],params[:file])
    head :ok
  end

  def reset
    investor = Investor.by_email(params[:email])
    if investor
      investor.token = SecureRandom.uuid
      investor.save
      ClientMailer.new_password(investor, investor.token).deliver_later
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
    investor = Investor.by_email(params[:email])
    if investor
      if investor.token == params[:token]
        investor.password = params[:password]
        investor.password_confirmation =  params[:password_confirmation]
        investor.token = nil
        investor.save
        ClientMailer.new_password_confirmation(investor,params[:password]).deliver_later
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

  def graphs
    if @investor
      p = Project.by_investor(id: @investor.id).ids
      render json: {
        data: {
          debt: Tracing.debt_by_year_and_month(p),
          interest: Tracing.interest_by_year_and_month(p),
          people: Project.capital_distribution(@investor.id) 
        }
      }
    else
      error_not_found
    end
  end

  private
  def investor_params
    params.require(:investor).permit(:step,:money_invest,:month,:monthly_payment,:profitability,:name,:lastname,:identification,:phone,:address,:birthday,:email,:city,:password,:password_confirmation,:employment_status,:education,:rent_tax,:terms_and_conditions,:career,:technical_career)
  end

  def payment_params
    params.require(:payment).permit(:name,:lastname,:card_number,:card_type,:ccv,:month,:year,:career,:technical_career)
  end

  def set_investor
    @investor = Investor.by_id(params[:id])
  end

end
