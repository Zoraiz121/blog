Rails.application.routes.draw do
  # ==> Authentication routes (Devise)
  devise_for :users

  # ==> Public routes
  root "articles#index"

  resources :articles, only: [ :index, :show ]

  # ==> Authenticated routes
  authenticate :user do
    resources :articles, only: [ :new, :create, :edit, :update, :destroy ] do
      resources :comments, only: [ :create, :destroy ]
    end

    # User profile — authenticated users can view their own profile
    resource :profile, only: [ :show ], controller: "profiles"
  end
end
