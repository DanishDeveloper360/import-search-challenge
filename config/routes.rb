Rails.application.routes.draw do
  # non-default versions have to be defined above the default version
  scope module: :v2, constraints: ApiVersion.new('v2') do
    resources :ports, only: :index
  end

  # namespace the controllers without affecting the URI
  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    resources :ports do
      collection do
        get 'search'
        get 'search_full_text'
        get 'search_partial_text'
      end
    end
  end 

  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
end