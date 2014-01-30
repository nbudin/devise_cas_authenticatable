Scenario::Application.routes.draw do
  devise_for :users
  cassy
  root :to => "home#index"
end
