class ApplicationController < ActionController::API
  include Secured
  after_action :set_header


  private
  
  def set_header
    @type = nil
    if @current_admin
      @type = "Admin"
    elsif @current_client
      @type = "Client"
    elsif @current_investor
      @type = "Investor"
    end
    response.headers['token'] = @token if @type
    response.headers['token-type'] = @type if @type
  end

  def error_render
    render json: {
      data: {
        errors: @object.errors
      }
    }, status: 500
  end

  def error_not_found
    render json: {
      data: {
        errors: ['Not found']
      }
    }, status: 404
  end

end
