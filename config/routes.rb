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
 
  get "/forgot_password" => "users#forgot_password"
  post "/forgot_password" => "users#mail_password_reset"
  get "/password_reset/:token" => "users#password_reset", :method => 'get'
  post "/password_reset/:token" => "users#update_password"
  get "/fetch" => "users#fetch_allusers"
  get "/admin" => "admin#index"
  get "users/admin/user/:userid", :to => 'admin#deleteuser', :method => 'delete'
  get "users/admin/make_admin/:userid", :to => 'admin#make_admin', :method => 'delete'
  get "users/admin/remove_admin/:userid", :to => 'admin#remove_admin', :method => 'delete'
  get "users/admin/edit_user/:userid", :to => 'admin#edit_user'
  post "users/admin/edit_user/:userid", :to => 'admin#update_user'

  mount ActionCable.server => '/cable'

 
  root "users#new"
end
