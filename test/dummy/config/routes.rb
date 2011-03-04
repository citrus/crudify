Dummy::Application.routes.draw do
  resources :jellies
  root :to => "jellies#index"
end