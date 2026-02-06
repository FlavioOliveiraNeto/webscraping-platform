Rails.application.routes.draw do
  namespace :api do
    resources :scraping_tasks, only: [:index, :create, :show, :destroy]
    post 'callbacks/tasks/:id', to: 'callbacks#update_task'
  end
end