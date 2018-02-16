require 'sidekiq/web'

Rails.application.routes.draw do
  scope '/api' do
  # scope '/v1' do
    post '/import_csv' => "home#import_csv"
    get  '/sites_list' => "sites#index"
    get  '/batch_list' => "sites#batch_list"
    mount Sidekiq::Web => '/sidekiq'

    namespace :users do
      resources :notifications, only: [:index, :update]
      resource :notification_counts, only: [:show, :destroy]
      post 'signup' => 'registrations#create'
      post 'signin' => 'sessions#create'
      post 'facebook/login' => 'facebook_logins#create'
      get ':username/posts' => 'posts#index'
      get ':username/public_profile' => 'public_profiles#show'
      get ':username/followers' => 'followers#index'
      get ':username/following' => 'following#index'
      resource :search, only: :show
      # get '/search' => 'search#show'
    end

    # Create Queries list
    post   'query/search' => 'queries#create'
    get    'query/search' => 'queries#create'
    get    'queries'      => 'queries#index'
    delete 'query/'       => 'queries#destroy'
    namespace :websites do
      get 'search' => 'search#index'
      # resource :search, only: :show
    end
    # get 'query/search' => "search#show"
    get "queries/search" => "search#queries"
    get "surf"        => "search_autocomplete#index"
    get "search"      => "search#show", as: :search
    # get "search"      => "search#websites", as: :search
    get "weby"        => "search#websites"
    get "search_user" => "search#users"

    get "sites/search" => "search#sites"
    # get "autocomplete" => "search_autocomplete#index"
    put 'me/avatar' => 'avatar_images#update'
    patch 'me' => 'users#update'

    post 'follow/:user_id' => 'relationships#create'
    delete 'unfollow/:user_id' => 'relationships#destroy'

    get 'posts/tags/:tag_name' => 'tags/posts#index'

    resources :posts, only: [:index, :create] do
      resource :likes, only: [:create, :destroy], module: :posts
      resources :comments, only: [:index, :create, :destroy], module: :posts
      resources :likers, only: [:index], module: :posts
    end

    resources :locations, only: [:show]

    resources :follow_suggestions, only: [:index]

    mount ActionCable.server => '/cable'
  end
end
