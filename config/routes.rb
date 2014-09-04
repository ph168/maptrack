MapTrack::Application.routes.draw do

  devise_for :users, :path => "auth", :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :unlock => 'unblock', :registration => 'register', :sign_up => 'cmon_let_me_in' }, :controllers => { :sessions => 'sessions', :registrations => 'registrations' }

  root :to => "tracks#index"

  resources :tracks do
    put 'close' => 'tracks#close'
    get 'coordinates/last' => 'coordinates#show_last'
    resources :coordinates do
      get 'place' => 'coordinates#place'
    end
    resources :places
  end

  get 'tracks/public/:share_token' => 'tracks#show'
  get 'tracks/public/:share_token/places' => 'places#index'
  get 'tracking/:token/track' => 'tracking#track'

  get 'user' => 'users#index'
  get 'user/search' => 'users#search'
  get 'user/_/edit' => 'users#edit', :as => 'edit_user'
  put 'user' => 'users#update'
  patch 'user' => 'users#update'
  match 'user/:name.:format' => 'users#show', :via => [:get], :constraints => {:name => /.*/}, :format => false

  post 'friendship' => 'friendships#request_friendship'
  put 'friendship/:id/confirm' => 'friendships#confirm_friendship'
  patch 'friendship/:id/confirm' => 'friendships#confirm_friendship'
  delete 'friendship/:id' => 'friendships#destroy_friendship'

  get 'stories' => 'stories#index'
  get 'stories/unseen/count' => 'stories#unseen_count'
  put 'stories/seen' => 'stories#seen_all'
  get 'stories/:id' => 'stories#show'
  put 'stories/:id/seen' => 'stories#seen'
end
