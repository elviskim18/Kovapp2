Rails.application.routes.draw do
  # devise_for :admin_users, ActiveAdmin::Devise.config
  # ActiveAdmin.routes(self)
  resources :posts
  root to: 'pages#home'
  get 'pages/home'

  get 'new', to: 'pages#register', as: :new_user_form
  get 'certificate/:id', to: 'pages#certificate', as: :certificate
  get 'certificates/:id', to: 'pages#show'
  get 'certificates' => 'pages#index'

  get 'user', to: 'api#user'
  post 'certificates/verify', to: 'api#verify'
  post 'new', to: 'pages#register_user', as: :new_user_registration
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }

  # api auth routes
  post 'authenticate', to: 'authentication#authenticate'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
