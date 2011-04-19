RailsApp::Application.routes.draw do
  devise_for :users
  resources :users, :only => [:index]
  root :to => 'home#index'
end

