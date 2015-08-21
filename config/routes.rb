Rails.application.routes.draw do
  resources :users, except: :index
  resource :session, only: [:new, :create, :destroy]
  resources :subs do
    resources :posts, only: :new
  end
  
  resources :posts, except: [:index, :new] do
    member do
      post "downvote"
      post "upvote"
    end
  end

  resources :comments, only: [:create, :destroy] do
    member do
      post "downvote"
      post "upvote"
    end
  end

  root to: 'subs#index'
end
