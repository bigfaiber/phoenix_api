class UsersController < ApplicationController
  before_action -> { authorize_user(['Admin']) }, only: [:index]
  
  def index
    clients = Client.pluck(:id, :name, :lastname, :identification).map{ |c| { id: c[0], fullname: "#{c[1]} #{c[2]}", identification: c[3], type: 'Client' } }
    investors = Investor.pluck(:id, :name, :lastname, :identification).map{ |i| { id: i[0], fullname: "#{i[1]} #{i[2]}", identification: i[3], type: 'Investor' }}
    
    render json: clients + investors, status: :ok
  end
  
end
