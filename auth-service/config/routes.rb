Rails.application.routes.draw do
  namespace :api do
    post 'signup', to: 'registrations#create'
    post 'login', to: 'sessions#create'
  end
end