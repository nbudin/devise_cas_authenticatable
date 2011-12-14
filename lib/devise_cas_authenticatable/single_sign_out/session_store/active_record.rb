ActiveRecord::SessionStore.class_eval do

  include DeviseCasAuthenticatable::SingleSignOut::SetSession
  alias_method_chain :set_session, :storage

  #def destroy_session(env, session_id, options)
  #  if session = Session::find_by_session_id(sid)
  #    session.destroy
  #  end
  #end

end
