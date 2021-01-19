class AuthenticateController < ApplicationController

  def login
    command = AuthenticateCommand.call(params[:email],params[:password])
    if command.success?
      render json: { data: {
        auth_token: command.result
        }
      }, status: :ok
    else
      render json: { data: {
        errors: command.errors
        }
      }, status: :unauthorized
    end
  end

end