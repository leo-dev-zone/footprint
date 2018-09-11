Footplate::Application.routes.draw do
  resources :feeds
  resources :users

  resource :scheduler, only: [:show, :edit, :update]

  resources :feed_entries, only: [:update] do
    member do
      post 'publish'
      post 'unpublish'
      post 'edit'
      post 'cancel_edit'
    end
  end

  devise_for :users, path: :account

  match '/feed' => 'home#feed'

  get "home/index"
  root :to => 'home#index'

  get 'authorize/twitter'
  get 'authorize/twitter_callback'

  get 'authorize/facebook'
  get 'authorize/facebook_callback'

  get 'authorize/linkedin'
  get 'authorize/linkedin_callback'

  match "/delayed_job" => DelayedJobWeb, :anchor => false
end
