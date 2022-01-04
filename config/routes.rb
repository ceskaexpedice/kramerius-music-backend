Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api  do
    resources :albums, only: [:index] do
      resources :tracks, only: [:index]
    end

    resources :playlists, only: [:index, :show, :update, :create, :destroy] do
      member do
        post 'tracks/:track_id', action: 'add_track'
        delete 'tracks/:track_id', action: 'remove_track'
      end
    end

    get 'embed/:pid', to: 'embed#show'

    get 'library/albums', to: 'library#albums'
    post 'library/albums/:album_id', to: 'library#add_album'
    delete 'library/albums/:album_id', to: 'library#remove_album'

    get 'library/artists', to: 'library#artists'
    post 'library/artists/:name', to: 'library#add_artist'
    delete 'library/artists/:name', to: 'library#remove_artist'


    get 'search/tracks', to: 'tracks#search'

  end

end
