class UsersController < ApplicationController
  before_action -> { authorize_user(['Admin']) }, only: [:index]
  
  def index
    
    pattern = pattern_params
    
    clients = Client.where('lower(name) LIKE ? OR lower(lastname) LIKE ? OR lower(identification) LIKE ?', pattern, pattern, pattern).pluck(:id, :name, :lastname, :identification, :client_type).map{ |c| { id: c[0], fullname: "#{c[1]} #{c[2]}", identification: c[3], type: 'Client', status: c[4] } }
    
    investors = Investor.where('lower(name) LIKE ? OR lower(lastname) LIKE ? OR lower(identification) LIKE ?', pattern, pattern, pattern).pluck(:id, :name, :lastname, :identification, :client_type).map{ |i| { id: i[0], fullname: "#{i[1]} #{i[2]}", identification: i[3], type: 'Investor', status: i[4] } }
    
    render json: clients + investors, adapter: nil, status: :ok
  end
  
  private
  
    def pattern_params
      if params[:pattern]
        "%#{ params[:pattern].downcase }%" 
      else
        '*'
      end
    end
  
end
