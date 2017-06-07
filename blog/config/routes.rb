Rails.application.routes.draw do
  root to: 'web_scraper#index'
  match '/request' => 'web_scraper#create', via: :get
end
