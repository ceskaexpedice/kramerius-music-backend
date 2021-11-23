Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api  do
    resources :albums, only: [:index] do
      resources :tracks, only: [:index]
    end

    get 'search/tracks', to: 'tracks#search'

  end

end
