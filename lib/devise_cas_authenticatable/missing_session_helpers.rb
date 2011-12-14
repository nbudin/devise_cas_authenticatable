module MissingSessionHelpers
  def new_session_path(resource_name, *args)
    send "new_#{resource_name}_session_path".to_sym, *args
  end
  
  def destroy_session_path(resource_name, *args)
    send "destroy_#{resource_name}_session_path".to_sym, *args
  end
end
