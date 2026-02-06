Rails.application.routes.draw do
  namespace :api do
    resources :notifications, only: [:create, :index]
  end
end