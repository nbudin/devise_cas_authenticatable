module DeviseCasAuthenticatable
  module SingleSignOut
    module SetSession
      def set_session_with_storage(env, sid, session_data)
        if session_data['cas_last_valid_ticket_store']
          ::DeviseCasAuthenticatable::SingleSignOut::Strategies.current_strategy.store_session_id_for_index(session_data['cas_last_valid_ticket'], sid)
          session_data['cas_last_valid_ticket_store'] = nil
        end

        set_session_without_storage(env, sid, session_data)
      end
    end
  end
end

if defined?(ActionDispatch)
  # Need to make a small extension to rails to expose the session_store to our controllers
  require 'action_dispatch/middleware/session/abstract_store'
  ActionDispatch::Session::AbstractStore.class_eval do
    def prepare_with_session_store!(env)
      prepare_without_session_store!(env)
      env[:session_store] = self
    end
    alias_method_chain :prepare!, :session_store
  end
end

require 'devise_cas_authenticatable/single_sign_out/strategies'
require 'devise_cas_authenticatable/single_sign_out/strategies/base'
require 'devise_cas_authenticatable/single_sign_out/strategies/rails_cache'