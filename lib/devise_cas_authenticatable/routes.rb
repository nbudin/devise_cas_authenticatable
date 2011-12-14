if defined?(ActionDispatch)
  # Rails 3
  
  ActionDispatch::Routing::Mapper.class_eval do
    protected
  
    def devise_bushido_authenticatable(mapping, controllers)
      # service endpoint for CAS server
      get "service", :to => "#{controllers[:cas_sessions]}#service", :as => "service"
      post "service", :to => "#{controllers[:cas_sessions]}#single_sign_out", :as => "single_sign_out"

      resource :session, :only => [], :controller => controllers[:cas_sessions], :path => "" do
        get :new, :path => mapping.path_names[:sign_in], :as => "new"
        get :unregistered
        post :create, :path => mapping.path_names[:sign_in]
        match :destroy, :path => mapping.path_names[:sign_out], :as => "destroy"
      end
    end
  end
else

  # Rails 2  
  ActionController::Routing::RouteSet::Mapper.class_eval do
    protected

    def bushido_authenticatable(routes, mapping)
      routes.with_options(:controller => 'devise/cas_sessions', :name_prefix => nil) do |session|
        session.send(:"#{mapping.name}_service", '/service', :action => 'service', :conditions => {:method => :get})
        session.send(:"#{mapping.name}_service", '/service', :action => 'single_sign_out', :conditions => {:method => :post})
        session.send(:"unregistered_#{mapping.name}_session", '/unregistered', :action => "unregistered", :conditions => {:method => :get})
        session.send(:"new_#{mapping.name}_session", mapping.path_names[:sign_in], :action => 'new', :conditions => {:method => :get})
        session.send(:"#{mapping.name}_session", mapping.path_names[:sign_in], :action => 'create', :conditions => {:method => :post})
        session.send(:"destroy_#{mapping.name}_session", mapping.path_names[:sign_out], :action => 'destroy', :conditions => { :method => :get })
      end
    end
  end
end
