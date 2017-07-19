Rails.application.routes.draw do
  scope '/api', defaults: {format: :json} do
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
    # get "autocomplete" => "search_autocomplete#index"
    # patch 'me/avatar' => 'avatar_images#update'
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


    resources :channels, only: [:show, :index]
    resources :messages, except: [:new, :edit]
    # get 'messages_search', to: 'messages#search'
    resources :direct_messages, except: [:new, :edit, :update]
    resources :channel_joins, only: [:create, :destroy, :index]

    mount ActionCable.server => '/cable'
  end
end
