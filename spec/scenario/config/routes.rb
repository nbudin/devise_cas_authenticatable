require 'castronaut/application'
Castronaut::Application.set(:path, "/cas_server")

Scenario::Application.routes.draw do
  devise_for :users
  mount Castronaut::Application, :at => "/cas_server"
  root :to => "home#index"
end
