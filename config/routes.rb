Trade::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount Blogit::Engine => "/blog"

  get '/auth/:provider/callback' => 'authentications#create'
  #devise_for :users, :controllers => {
  #                                    :registrations => 'registrations',
  #                                    :omniauth_callbacks => 'omniauth_callbacks'
  #                                   }
  devise_for :users, :controllers => {
                                      :registrations => 'users',
                                      :omniauth_callbacks => 'omniauth_callbacks'
                                     }

  resources :authentications

  get '/about' => 'static#about'
  get '/tos' => 'static#tos'
  get '/transactions' => 'static#transactions'
  get '/privacy_policy' => 'static#privacy_policy'
  get '/thanks' => 'static#thanks'
  get '/under_construction' => 'static#under_construction'

  devise_scope :user do
    resources :users
    unauthenticated do
      root :to => "users#index"
    end
    authenticated :user do
      root :to => 'users#edit', as: :authenticated_root
    end
  end
end

Blogit::Engine.routes.draw do
  devise_for :users, :controllers => {
                                      :registrations => 'registrations',
                                      :omniauth_callbacks => 'omniauth_callbacks'
                                     }
end
