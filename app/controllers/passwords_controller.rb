class PasswordsController < ApplicationController
  
  def reset
    types = ['Client', 'Investor']
    user = nil
    types.each do |type|
      user = Kernel.const_get(type).by_email(params[:email])
      break if user
    end
  
    if user
      user.token = SecureRandom.uuid
      user.save
      
      ClientMailer.new_password(user, user.token).deliver_later
      render json: {
        data: {
          message: 'We have sent an email with the instructions'
        }
      }, status: :ok
    else
      render json: {
        data: {
          errors: ["We don't have an user with that email"]
        }
      }, status: 500
    end
  end
  
  def update
    if ['Client', 'Investor'].include?(params[:type])
      @current_user = Kernel.const_get(data[:type]).by_email(params[:email])
      
      if @current_user
        if @current_user.token == params[:token]
          @current_user.password = params[:password]
          @current_user.password_confirmation = params[:password_confirmation]
          @current_user.token = nil
          @current_user.save
          ClientMailer.new_password_confirmation(@current_user, params[:password]).deliver_later
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
      
    else
      render json: {data: {
        errors: ["We don't have a client with that email"]
        }}, status: 500
      
    end

  end
  
end
