Footplate::Application.routes.draw do
  resources :feeds
  resources :users

  resource :scheduler, only: [:show, :edit, :update]

  resources :feed_entries do
    member do
      post 'publish'
      post 'unpublish'
    end
  end

  devise_for :users, path: :account

  get "home/index"
  root :to => 'home#index'

  match "/delayed_job" => DelayedJobWeb, :anchor => false
end
