module DeviseCasAuthenticatable
  module SingleSignOut
    module SetSession
      def set_session_with_storage(env, sid, session_data, options={})
        if session_data['cas_last_valid_ticket_store']
          ::DeviseCasAuthenticatable::SingleSignOut::Strategies.current_strategy.store_session_id_for_index(session_data['cas_last_valid_ticket'], sid)
          session_data['cas_last_valid_ticket_store'] = nil
        end

        if method(:set_session_without_storage).arity == 4
          set_session_without_storage(env, sid, session_data, options)
        else
          set_session_without_storage(env, sid, session_data)
        end        
      end
    end
  end
end

require 'devise_cas_authenticatable/single_sign_out/strategies'
require 'devise_cas_authenticatable/single_sign_out/strategies/base'
require 'devise_cas_authenticatable/single_sign_out/strategies/rails_cache'