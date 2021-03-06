Rails.application.routes.draw do
  # resources :opinions
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #constraints subdomain: "api" do
    get 'projects/:id/amortization-table', to: "projects#generate_table", defaults: { format: 'pdf' }
    scope '/', defaults: { format: 'json' } do
      get '/send-verification-code', to: "validate_phones#send_verification_code"
      post '/reset-password', to: "passwords#reset"
      get '/average-interest', to: "static#average_interest"
      get '/projects-values-interest', to: "static#projects_values_interest"
      post '/login',  to: "authenticate#login"
      get '/users',  to: "users#index"
      resources :financial_status, only: [:update]
      resources :receipts, only: [] do
        member do
          post 'grade', to: "receipts#grade"
        end
      end
      resources :inv_accounts, except: [:destroy]
      resources :profitabilities
      resources :opinions, only: [:update, :destroy]
      resources :opinion_invs, only: [:update,:destroy]
      resources :clients do
        resources :opinions, only: [:index,:create]
        member do
          post 'add-additional-data', to: "clients#additional_data"
          post 'grade', to: "clients#grade"
          get 'graph-values', to: "clients#graph"
        end
        collection do
          get 'not-valid', to: "clients#not_valid"
          get 'end-sign-up', to: "clients#end_sign_up"
          get 'reset-password', to: "clients#reset"
          post 'new-password', to: "clients#new_password"
          get 'by-token', to: "clients#token"
          get 'new-code', to: "clients#new_verification_code"
          get 'new-clients', to: "clients#new_clients"
          get 'old-clients', to: "clients#old_clients"
          get 'verification', to: "clients#verification"
          post 'upload-avatar', to: "clients#avatar"
          post 'upload-facebook-avatar', to: "clients#facebook_avatar"
          post 'create-goods', to: "clients#goods"
          post 'upload-document', to: "clients#documents"
        end
        resources :projects, only: [:index], controller: 'clients/projects'
      end
      resources :investors do
        resources :inv_accounts, only: [:index, :create]
        member do
          get 'graphs', to: "investors#graphs"
          post 'change-maximum', to: "investors#maximum"
        end
        resources :opinion_invs, only: [:index,:create]
        resources :projects, only: [] do
          member do
            post 'match', to: "projects#match"
          end
        end
        collection do
          get 'end-sign-up', to: "investors#end_sign_up"
          get 'reset-password', to: "investors#reset"
          post 'new-password', to: "investors#new_password"
          get 'by-token', to: "investors#token"
          get 'new-code', to: "investors#new_verification_code"
          get 'new-investors', to: "investors#new_investors"
          get 'old-investors', to: "investors#old_investors"
          get 'verification', to: "investors#verification"
          post 'upload-avatar', to: "investors#avatar"
          post 'upload-facebook-avatar', to: "investors#facebook_avatar"
          post 'create-payment', to: "investors#payment"
          post 'upload-document', to: "investors#documents"
        end
        resources :projects, only: [:update, :index], controller: 'investors/projects'
      end
      resources :admins do
        collection do
          get 'by-token', to: "admins#token"
          post 'upload-avatar', to: "admins#avatar"
        end
      end
      namespace :projects do
        resources :assign_investors, only: [:update]
      end
      resources :projects, only: [:create,:update,:destroy,:show,:index] do
        collection do
          post 'create-by-admin', to: "projects#create_admin"
          get 'by-clients', to: "projects#clients"
          get 'by-investors', to: "projects#investors"
          get 'search', to: "projects#search"
          get 'historical', to: "projects#historical"
          get 'by-code', to: "projects#by_code"
        end
        member do
          post 'add-month-balance', to: "projects#add_month_balance"
          post 'add-warranty', to: "projects#add_warranty"
          post 'finish', to: "projects#finish"
          post 'add-table', to: "projects#add_table"
          post 'new-project', to: "projects#new_project"
          post 'change-interest', to: "projects#rate"
          post 'add-account', to: "projects#account"
          post 'add-inv-account', to: "projects#inv_account"
          post 'approve-project', to: "projects#approve"
          post 'like', to: "projects#like"
          post 'add-receipt', to: "projects#receipt"
        end
      end
      resources :matches, only: [:index] do
        collection do
          get 'grouped', to: "matches#grouped"
          get 'current-projects', to: "matches#current_projects"
        end
      end
      resources :documents, only: [] do
        member do
          put 'replace-document', to: "documents#replace"
        end
      end
    end
  #end

end
