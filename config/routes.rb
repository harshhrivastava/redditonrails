Rails.application.routes.draw do
  root to: "subreddits#index"

  get ":page", to: "subreddits#index", as: "page"
  
  resources :subreddits do
    resources :comments, only: [:new, :create]
    get ":page", to: "subreddits#show", as: "page"
  end

  resources :comments, except: [:new, :create] do
    resources :comments, only: [:new, :create]
    get ":page", to: "comments#show", as: "page"
  end
end