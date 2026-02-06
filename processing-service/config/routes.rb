Rails.application.routes.draw do
  namespace :api do
    post 'scrape', to: 'scraping#create'
  end
end