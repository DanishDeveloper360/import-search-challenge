Rails.application.routes.draw do
  resources :ports do
    collection do
      get 'search'
    end
  end
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
end