Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users
  resources :posts
  resources :followers
  # get "/test" => "users#test"
  get "/login"      => "users#login"
  get "/logout"     => "users#log_out"
  post "/login"     => "users#login_user"
  post "/post_tweet"=> "posts#post_tweet"
  get "/isfollow"   => "followers#isfollow"
  get "/unfollow"   => "followers#unfollow"
  get "/following"   => "followers#following"
  root "users#new"
end
