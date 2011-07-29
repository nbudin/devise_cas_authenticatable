ActiveRecord::SessionStore::Session.class_eval do

  def create_with_session_stored
    result = create_without_session_stored
    if ::Devise.cas_enable_single_sign_out && result && self.data['cas_last_valid_ticket']
      ::DeviseCasAuthenticatable::SingleSignOut::Strategies.current_strategy.store_session_id_for_index(self.data['cas_last_valid_ticket'], self.session_id)
    end

    result
  end
  alias_method_chain :create, :session_stored

end

ActiveRecord::SessionStore.class_eval do

  def destroy_session(sid)
    if session = Session::find_by_session_id(sid)
      session.destroy
    end
  end

end
