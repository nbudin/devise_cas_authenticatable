module ActionDispatch::Routing
  class RouteSet
    class Mapper
    protected
  
      def devise_cas(mapping, controllers)
        scope mapping.full_path do
          get mapping.path_names[:sign_out], :to => "#{controllers[:cas]}#destroy", :as => :"destroy_#{mapping.name}_session"
        end
      end
    end
  end
end