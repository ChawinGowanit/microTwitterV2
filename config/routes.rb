Rails.application.routes.draw do
  resources :posts
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'main' ,to: 'users#login'
  post 'main' , to: 'users#check' , as: "check"
  get 'feed', to: 'users#feed'
  get "profile/:name", to: "users#viewUser"
  post "profile/:name", to: "users#manageFollow", as: "manageFollow"

  post "like", to: "users#like"
  post "unlike", to: "users#unlike"

end
