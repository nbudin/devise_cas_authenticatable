require 'action_dispatch/routing/mapper'

module ActionDispatch::Routing
  class Mapper
    protected
  
    def devise_cas(mapping, controllers)
      # service endpoint for CAS server
      get "/", :to => "#{controllers[:cas_sessions]}#service"
      
      get :new, :path => mapping.path_names[:sign_in], :to => "#{controllers[:cas_sessions]}#create"
      get :create, :path => mapping.path_names[:sign_in], :as => ""
      get :destroy, :path => mapping.path_names[:sign_out]
    end
  end
end
