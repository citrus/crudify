Dummy::Application.routes.draw do

  namespace :admin do
    resources :peanut_butters
    root :to => "peanut_butters#index"
  end

  resources :jellies
  root :to => "jellies#index"

end