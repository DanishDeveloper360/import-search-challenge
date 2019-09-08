Rails.application.routes.draw do
  resources :ports do
    collection do
      get 'search'
    end
  end
end