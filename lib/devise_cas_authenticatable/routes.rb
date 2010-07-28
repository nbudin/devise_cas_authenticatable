require 'action_dispatch/routing/mapper'

module ActionDispatch::Routing
  class Mapper
    protected
  
    def devise_cas(mapping, controllers)
      # service endpoint for CAS server
      get "/", :to => "#{controllers[:cas_sessions]}#service"
      
      get mapping.path_names[:sign_in], :to => "#{controllers[:cas_sessions]}#create", :as => :"new_#{mapping.name}_session"
      post mapping.path_names[:sign_in], :to => "#{controllers[:cas_sessions]}#create", :as => :"#{mapping.name}_session"
      get mapping.path_names[:sign_out], :to => "#{controllers[:cas_sessions]}#destroy", :as => :"destroy_#{mapping.name}_session"
    end
  end
end
