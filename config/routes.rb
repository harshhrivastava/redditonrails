Rails.application.routes.draw do
  root to: "subreddits#index"
  
  resources :subreddits do
    resources :comments, only: [:new, :create]
  end

  resources :comments, except: [:new, :create] do
    resources :comments, only: [:new, :create]
  end
end