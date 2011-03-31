ENV['CONFIG_FILE'] = File.expand_path('../rubycas-server.yml', __FILE__)
require 'casserver'

Scenario::Application.routes.draw do
  devise_for :users
  match "/cas_server/*args" => CASServer::Server, :as => "cas_server"
  root :to => "home#index"
end
