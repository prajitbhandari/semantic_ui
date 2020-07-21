Rails.application.routes.draw do
  root to: "users#index"
  devise_for :users, :controllers => { :registrations => 'registrations'}
  resources :users, except: [:new, :create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
