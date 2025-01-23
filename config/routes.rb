Rails.application.routes.draw do
  root "xml_documents#index"
  resources :xml_documents, only: [ :index, :new, :create, :show ]
  resources :xml_documents do
    member do
      post :parse_users
    end
  end
  resources :license_users, only: [ :index, :show ]
end
