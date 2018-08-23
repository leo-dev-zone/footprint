Footplate::Application.routes.draw do
  resources :feeds
  resources :users

  devise_for :users, path: :account

  get "home/index"
  root :to => 'home#index'

  match "/delayed_job" => DelayedJobWeb, :anchor => false
end
