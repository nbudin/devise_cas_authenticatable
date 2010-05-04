ActionController::Routing::RouteSet::Mapper.class_eval do
  protected
  
  def cas_authenticatable(routes, mapping)
    routes.with_options(:controller => 'cas_sessions', :name_prefix => nil) do |session|
      session.send(:"destroy_#{mapping.name}_session", mapping.path_names[:sign_out], :action => 'destroy', :conditions => { :method => :get })
    end
  end
end