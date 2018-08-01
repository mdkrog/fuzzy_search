Rails.application.routes.draw do
  namespace :v1 do
    get 'search', to: 'items#index'
  end
end
