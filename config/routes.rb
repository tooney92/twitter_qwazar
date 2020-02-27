Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users
  # get "/test" => "users#test"
  get "/login" => "users#login"
  get "/logout" => "users#log_out"
  post "/login" => "users#login_user"
 
  root "users#new"
end
