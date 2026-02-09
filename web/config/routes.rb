Rails.application.routes.draw do
  # Autenticacao
  get    "login",  to: "sessions#new",     as: :login
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  # Registro
  get  "signup", to: "registrations#new",    as: :signup
  post "signup", to: "registrations#create"

  # Tarefas de scraping
  resources :scraping_tasks, only: [ :index, :new, :create, :show ]

  # Raiz
  root "scraping_tasks#index"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
