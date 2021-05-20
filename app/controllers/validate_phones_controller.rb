class ValidatePhonesController < ApplicationController
  
  def send_verification_code
    begin
      code = SecureRandom.uuid[0..7]
      MessageSender.send_message(code, params[:phone])
      render json: {
        data: {
          message: 'code sent',
          code: code
        }
      }, status: :ok
    rescue Twilio::REST::TwilioError, Twilio::REST::RestError => error
      return render json: {
        data: {
          errors: ["We can't send the code"]
        }
      }, status: 500
    end
    # head :ok
    
    # code = SecureRandom.uuid[0..7]
    # 
    # render json: {
    #   data: {
    #     message: 'code sent',
    #     code: code
    #   }
    # }, status: :ok
  end
  
end