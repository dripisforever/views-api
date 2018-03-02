require 'sidekiq/web'

Rails.application.routes.draw do
  # # views.ly/vc.ru/top-investments
  # get '/:website' => "website#index"
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
    end

    # Create Queries list
    post   'query/search' => 'queries#create'
    get    'query/search' => 'queries#create'
    get    'queries'      => 'queries#index'
    delete 'query/'       => 'queries#destroy'

    namespace :websites do
      get 'search' => 'search#index'
    end

    #Search Endpoint
    get "queries/search" => "search#queries"
    get "surf"           => "search_autocomplete#index"
    get "search"         => "search#show", as: :search
    get "weby"        => "search#websites"
    get "search_user" => "search#users"
    get "sites/search" => "search#sites"
    # get "search"      => "search#websites", as: :search
    # get "autocomplete" => "search_autocomplete#index"

    #Avatar Upload
    put   'me/avatar' => 'avatar_images#update'
    patch 'me'      => 'users#update'

    #Follow Endpoint
    post   'follow/:user_id'   => 'relationships#create'
    delete 'unfollow/:user_id' => 'relationships#destroy'

    #Tags index
    get 'posts/tags/:tag_name' => 'tags/posts#index'

    #Post Endpoints
    resources :posts, only: [:index, :create] do
      resource :likes, only: [:create, :destroy], module: :posts
      resources :comments, only: [:index, :create, :destroy], module: :posts
      resources :likers, only: [:index], module: :posts
    end

    #Locations
    resources :locations, only: [:show]

    #Following Suggestion
    resources :follow_suggestions, only: [:index]

    mount ActionCable.server => '/cable'
  end
end
