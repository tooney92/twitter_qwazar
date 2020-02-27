Rails.application.routes.draw do
  resources :posts
  resources :followers do
    collection do
      get :following
      get :unfollow
    end
  end
  resources :users
end
