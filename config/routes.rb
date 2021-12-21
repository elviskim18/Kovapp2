Rails.application.routes.draw do
  # devise_for :admin_users, ActiveAdmin::Devise.config
  # ActiveAdmin.routes(self)
  resources :posts
  root to: 'pages#home'
  get 'pages/home'
  get 'new', to: 'pages#register', as: :new_user_form
  post 'new', to: 'pages#register_user', as: :new_user_registration
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }
  resources :certificates

  post 'auth/login', to: 'auth#login'
  delete 'auth/logout', to: 'auth#logout'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
