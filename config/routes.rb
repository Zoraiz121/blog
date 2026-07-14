Rails.application.routes.draw do
  devise_for :users

  root "articles#index"
  resources :users, only: [ :show ]

  resources :articles do
    resources :comments, only: [ :create, :edit, :update, :destroy ]
  end

  resource :profile, only: [ :show ], controller: "profiles"
end
