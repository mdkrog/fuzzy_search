Rails.application.routes.draw do
  namespace :v1 do
    get 'search', to: 'search_items#index'
  end
end
