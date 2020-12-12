Rails.application.routes.draw do

  root 'auth#index'
  get '/auth/github', to: 'auth#login', as: :auth_github
  get '/auth/github/cb', to: 'auth#cb', as: :github
  get '/list/user', to: 'auth#list_user', as: :list_user
  delete 'logout', to: 'auth#logout', as: 'logout'

  resources :repositories do
    get "more", on: :collection
    put "star", on: :member
    put "unstar", on: :member
  end
  get '/repositories', to: 'repositories#index', as: :repository_list
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
