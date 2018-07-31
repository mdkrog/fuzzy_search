Rails.application.routes.draw do
  get 'search', to: 'search_items#index'
end
