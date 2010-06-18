require 'action_dispatch/routing/mapper'

module ActionDispatch::Routing
  class Mapper
    protected
  
    def devise_cas(mapping, controllers)
      # service endpoint for CAS server
      get mapping.full_path, :to => "cas_sessions#service"
      
      scope mapping.full_path do
        get mapping.path_names[:sign_out], :to => "cas_sessions#destroy", :as => :"destroy_#{mapping.name}_session"
      end
    end
  end
end