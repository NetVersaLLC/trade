Trade::Application.routes.draw do
  get '/auth/:provider/callback' => 'authentications#create'
  devise_for :users, :controllers => {
                                      :registrations => 'registrations',
                                      :omniauth_callbacks => 'omniauth_callbacks'
                                     }

  resources :users
  resources :authentications

  get '/about' => 'static#about'
  get '/tos' => 'static#tos'
  get '/transactions' => 'static#transactions'
  get '/privacy_policy' => 'static#privacy_policy'
  get '/thanks' => 'static#thanks'
  get '/under_construction' => 'static#under_construction'
  root :to => "users#index"

  authenticated :user do
    root :to => 'users#edit'
  end
  root :to => "users#index"
end
