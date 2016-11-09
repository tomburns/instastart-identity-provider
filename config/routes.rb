Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/authenticate', to: 'authentication#identity_token'
  match '/deployed', to: 'application#deployed', via: [:get, :options]

  resources :users

  root to: 'application#home'
end
