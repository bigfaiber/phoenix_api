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

  def pagination_dict(collection)
  {
    current_page: collection.current_page,
    next_page: collection.next_page,
    prev_page: collection.previous_page , # use collection.previous_page when using will_paginate
    total_pages: collection.total_pages,
    total_count: collection.total_entries
  }
  end

  def pagination_dict_new_client(collection)
  {
    current_page: collection.current_page,
    next_page: collection.next_page,
    prev_page: collection.previous_page , # use collection.previous_page when using will_paginate
    total_pages: collection.total_pages,
    total_count: collection.total_entries,
    new_clients: Client.new_clients.valid_form.count
  }
  end

  def pagination_dict_old_client(collection)
  {
    current_page: collection.current_page,
    next_page: collection.next_page,
    prev_page: collection.previous_page , # use collection.previous_page when using will_paginate
    total_pages: collection.total_pages,
    total_count: collection.total_entries,
    new_projects: Project.new_projects.length
  }
  end

end
