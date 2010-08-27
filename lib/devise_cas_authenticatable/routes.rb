if ActionController::Routing.name =~ /ActionDispatch/
  # Rails 3
  
  ActionDispatch::Routing::Mapper.class_eval do
    protected
  
    def devise_cas_authenticatable(mapping, controllers)
      scope :controller => controllers[:cas_sessions], :as => :session do
        # service endpoint for CAS server
        get "/", :to => "#{controllers[:cas_sessions]}#service"
      
        get :new, :path => mapping.path_names[:sign_in], :to => "#{controllers[:cas_sessions]}#create"
        get :create, :path => mapping.path_names[:sign_in], :as => ""
        get :destroy, :path => mapping.path_names[:sign_out]
      end
    end
  end
else
  # Rails 2
  
  ActionController::Routing::RouteSet::Mapper.class_eval do
    protected
    
    def cas_authenticatable(routes, mapping)
      routes.with_options(:controller => 'devise/cas_sessions', :name_prefix => nil) do |session|
        session.connect(mapping.raw_path, :action => 'service', :conditions => {:method => :get})
        session.send(:"new_#{mapping.name}_session", mapping.path_names[:sign_in], :action => 'create', :conditions => {:method => :get})
        session.send(:"#{mapping.name}_session", mapping.path_names[:sign_in], :action => 'create', :conditions => {:method => :post})
        session.send(:"destroy_#{mapping.name}_session", mapping.path_names[:sign_out], :action => 'destroy', :conditions => { :method => :get })
      end
    end
  end
end