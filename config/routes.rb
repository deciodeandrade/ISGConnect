Rails.application.routes.draw do
  resources :comments
  mount_devise_token_auth_for 'User', at: 'auth/user'

  get 'home' => 'home#index'

  resources :posts
end
