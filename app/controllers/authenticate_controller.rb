class AuthenticateController < ApplicationController

  def login
    command = AuthenticateCommand.call(params[:email],params[:password],params[:type])
    if command.success?
      render json: { data: {
        auth_token: command.result
        }
      }
    else
      render json: { data: {
        errors: command.errors
        }
      }, status: :unauthorized
    end
  end

end
