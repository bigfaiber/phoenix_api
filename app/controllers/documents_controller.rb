class DocumentsController < ApplicationController
  before_action :authenticate_admin_or_client_investor!
  before_action :set_document, only: [:replace]

  def replace
    if @document
      if @current_admin
        @document.document = params[:file]
        if @document.save
          render json: @document, serializer: DocumentSerializer, status: :ok
        else
          @object = @document
          error_render
        end
      elsif @current_client
        if @document.imageable_id == @current_client.id && @document.imageable_type == @current_client.class.name
          @document.document = params[:file]
          if @document.save
            render json: @document, serializer: DocumentSerializer, status: :ok
          else
            @object = @document
            error_render
          end
        else
          error_not_authorized
        end
      elsif @current_investor
        if @document.imageable_id == @current_investor.id && @document.imageable_type == @current_investor.class.name
          @document.document = params[:file]
          if @document.save
            render json: @document, serializer: DocumentSerializer, status: :ok
          else
            @object = @document
            error_render
          end
        else
          error_not_authorized
        end
      end
    else
      error_not_found
    end
  end

  private
  def set_document
    @document = Document.by_id(params[:id])
  end
end
