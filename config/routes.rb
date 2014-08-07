MapTrack::Application.routes.draw do

  devise_for :users, :path => "auth", :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :unlock => 'unblock', :registration => 'register', :sign_up => 'cmon_let_me_in' }, :controllers => { :sessions => 'sessions' }

  root :to => "tracks#index"

  resources :tracks do
    put 'close' => 'tracks#close'
    get 'coordinates/last' => 'coordinates#show_last'
    resources :coordinates do
      get 'place' => 'coordinates#place'
    end
    resources :places
  end

  get 'user' => 'users#index'
  get 'user/_/edit' => 'users#edit', :as => 'edit_user'
  put 'user' => 'users#update'
  patch 'user' => 'users#update'
  match 'user/:name.:format' => 'users#show', :via => [:get], :constraints => {:name => /.*/}, :format => false
  post 'user/friendship' => 'users#request_friendship'
  put 'user/friendship/:id/confirm' => 'users#confirm_friendship'
  patch 'user/friendship/:id/confirm' => 'users#confirm_friendship'
end
