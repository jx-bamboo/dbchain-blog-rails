Rails.application.routes.draw do
  root "articles#index"

  resources :users
  get 'sign_up', to: 'users#new'
  get 'sms', to: 'users#sms'
  delete 'sign_out', to: 'users#sign_out'
  get 'login', to: 'users#login'
  post 'login', to: 'users#login'
  get 'info', to: 'users#info'

  resources :articles do
    resources :comments
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
