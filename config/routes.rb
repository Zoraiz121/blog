Rails.application.routes.draw do
  devise_for :users

  root "articles#index"
  get "dashboard", to: "dashboard#index", as: :dashboard
  resources :users, only: [ :show ]

  resources :articles, shallow: true do
    resources :comments, only: [ :create, :edit, :update, :destroy ]
  end

  resource :profile, only: [ :show ], controller: "profiles"
end
