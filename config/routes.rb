Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '/', defaults: { format: 'json' } do
    post '/login',  to: "authenticate#login"
    resources :clients do
      collection do
        get 'verification', to: "clients#verification"
        post 'upload-avatar', to: "clients#avatar"
        post 'create-goods', to: "clients#goods"
        post 'upload-document', to: "clients#documents"
      end
    end
    resources :investors do
      collection do
        get 'verification', to: "investors#verification"
        post 'upload-avatar', to: "investors#avatar"
        post 'create-payment', to: "investors#payment"
        post 'upload-document', to: "investors#documents"
      end
    end
    resources :admins
  end

end
