module Secured
  extend ActiveSupport::Concern
  attr_reader :current_client, :current_investor, :current_admin, :token
  
  def authorize_user(valid_types = [])
    begin
      data = decode_token

      raise JWT::VerificationError unless valid_types.include?(data[:type])
      
      @current_user = Kernel.const_get(data[:type]).by_id(data[:id])

      raise JWT::VerificationError unless @current_user
      
      @type = data[:type]
      @token = JsonWebToken.encode(payload: { id: @current_user.id, type: @current_user.class.name })
      
    rescue JWT::VerificationError, JWT::DecodeError
      render json: { errors: ['Not authorized'] }, status: :unauthorized
    end
  end
  
  def authenticate_admin_or_client!
    begin
      obj = decode_token
      if obj[:type] == "Client"
        @current_client = Client.by_id(obj[:id])
        unless @current_client
          raise JWT::VerificationError
        end
        @type = obj[:type]
        @token = JsonWebToken.encode(payload: {id: @current_client.id,type: @current_client.class.name})
      elsif obj[:type] == "Admin"
        @current_admin = Admin.by_id(obj[:id])
        unless @current_admin
          raise JWT::VerificationError
        end
        @type = obj[:type]
        @token = JsonWebToken.encode(payload: {id: @current_admin.id,type: @current_admin.class.name})
      else
        raise JWT::VerificationError
      end
    rescue JWT::VerificationError, JWT::DecodeError
      render json: { data: {
        errors: ['Not authorized']
        }
      }, status: :unauthorized
    end

  end

  def authenticate_admin_or_client_investor!
    begin
      obj = decode_token
      if obj[:type] == "Client"
        @current_client = Client.by_id(obj[:id])
        unless @current_client
          raise JWT::VerificationError
        end
        @type = obj[:type]
        @token = JsonWebToken.encode(payload: {id: @current_client.id,type: @current_client.class.name})
      elsif obj[:type] == "Admin"
        @current_admin = Admin.by_id(obj[:id])
        unless @current_admin
          raise JWT::VerificationError
        end
        @type = obj[:type]
        @token = JsonWebToken.encode(payload: {id: @current_admin.id,type: @current_admin.class.name})
      elsif obj[:type] == "Investor"
        @current_investor = Investor.by_id(obj[:id])
        unless @current_investor
          raise JWT::VerificationError
        end
        @type = obj[:type]
        @token = JsonWebToken.encode(payload: {id: @current_investor.id,type: @current_investor.class.name})
      else
        raise JWT::VerificationError
      end
    rescue JWT::VerificationError, JWT::DecodeError
      render json: { data: {
        errors: ['Not authorized']
        }
      }, status: :unauthorized
    end

  end

  def authenticate_admin_or_investor!
    begin
      obj = decode_token
      if obj[:type] == "Investor"
        @current_investor = Investor.by_id(obj[:id])
        unless @current_investor
          raise JWT::VerificationError
        end
        @type = obj[:type]
        @token = JsonWebToken.encode(payload: {id: @current_investor.id,type: @current_investor.class.name})
      elsif obj[:type] == "Admin"
        @current_admin = Admin.by_id(obj[:id])
        unless @current_admin
          raise JWT::VerificationError
        end
        @type = obj[:type]
        @token = JsonWebToken.encode(payload: {id: @current_admin.id,type: @current_admin.class.name})
      else
        raise JWT::VerificationError
      end
    rescue JWT::VerificationError, JWT::DecodeError
      render json: { data: {
        errors: ['Not authorized']
        }
      }, status: :unauthorized
    end

  end

  def authenticate_admin!
    begin
      obj = decode_token
      if obj['type'] != "Admin"
        raise JWT::VerificationError
      else
        @current_admin = Admin.by_id(obj[:id])
        unless @current_admin
          raise JWT::VerificationError
        end
        @type = obj[:type]
        @token = JsonWebToken.encode(payload: {id: @current_admin.id,type: @current_admin.class.name})
      end
    rescue JWT::VerificationError, JWT::DecodeError
      render json: { data: {
        errors: ['Not authorized']
        }
      }, status: :unauthorized
    end
  end

  def authenticate_client!
    begin
      obj = decode_token
      if obj['type'] != "Client"
        raise JWT::VerificationError
      else
        @current_client = Client.by_id(obj[:id])
        unless @current_client
          raise JWT::VerificationError
        end
        @type = obj[:type]
        @token = JsonWebToken.encode(payload: {id: @current_client.id,type: @current_client.class.name})
      end
    rescue JWT::VerificationError, JWT::DecodeError
      render json: { data: {
        errors: ['Not authorized']
        }
      }, status: :unauthorized
    end
  end

  def authenticate_investor!
    begin
      obj = decode_token
      if obj[:type] != "Investor"
        raise JWT::VerificationError
      else
        @current_investor = Investor.by_id(obj[:id])
        unless @current_investor
          raise JWT::VerificationError
        end
        @type = obj[:type]
        @token = JsonWebToken.encode(payload: {id: @current_investor.id,type: @current_investor.class.name})
      end
    rescue JWT::VerificationError, JWT::DecodeError
      render json: { data: {
        errors: ['Not authorized']
        }
      }, status: :unauthorized
    end
  end

  private

  def decode_token
    JsonWebToken.decode(http_token)
  end

  def http_token
    if request.headers['HTTP_AUTHORIZATION'].present?
      values = request.headers['HTTP_AUTHORIZATION'].split(' ')
      if values[0] == "Bearer"
        return values.last
      else
        return nil
      end
    else
      nil
    end
  end

end
