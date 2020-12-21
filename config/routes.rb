Rails.application.routes.draw do
  root 'auth#index'

  get '/auth/github', to: 'auth#login'
  get '/auth/github/callback', to: 'auth#callback'
  delete 'logout', to: 'auth#logout', as: :logout
  get '/user_profile', to: 'auth#user_profile', as: :user_profile
  resources :repositories do
    get "more", on: :collection
    put "star", on: :member
    put "unstar", on: :member
    get "/:owner/:name/stargazers", on: :member, to: 'repositories#stargazers', as: :stargazers
    get "/:owner/:name/more_stargazers", on: :member, to: 'repositories#more_stargazers', as: :more_stargazers
    get "/:owner/:name/issues", on: :member, to: 'repositories#issues', as: :issues
    get "/:owner/:name/more_issues", on: :member, to: 'repositories#more_issues', as: :more_issues
  end

  get '/repositories', to: 'repositories#index', as: :repository_list

end
