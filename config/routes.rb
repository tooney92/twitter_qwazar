Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/users" => "users#new"
  get "/test" => "users#test"
  post "/users" => "users#create"
  root "users#index"
end
