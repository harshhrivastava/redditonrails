Rails.application.routes.draw do
  # Root Route
  root to: "subreddits#index"

  # Authentication Routes
  get "/signup", to: "users#new"
  resources :users, only: [:create, :edit, :update, :delete]

  # Session Routes
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"

  # Root Route's Page (For Pagination Feature)
  get "/page/:page", to: "subreddits#index", as: "page"

  # Model Routes
  resources :subreddits do
    resources :comments, only: [:new, :create]
    get "/page/:page", to: "subreddits#show", as: "page"
  end

  resources :comments, except: [:new, :create] do
    resources :comments, only: [:new, :create]

    # Comment Route's Page (For Pagination Feature)
    get "/page/:page", to: "comments#show", as: "page"
  end
end