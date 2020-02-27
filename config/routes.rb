Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users
  # get "/test" => "users#test"
  get "/login" => "users#login"
  get "/logout" => "users#log_out"
  post "/login" => "users#login_user"
  get "/forgot_password" => "users#forgot_password"
  post "/forgot_password" => "users#mail_password_reset"
  get "/password_reset/:token" => "users#password_reset", :method => 'get'
  post "/password_reset/:token" => "users#update_password"

 
  root "users#new"
end
