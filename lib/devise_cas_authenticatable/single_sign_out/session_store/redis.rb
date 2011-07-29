require "action_controller/session/redis_session_store"

module DeviseCasAuthenticatable
  module SingleSignOut
    module RedisSessionStore
      def set_session_with_session_stored(env, sid, session_data)
        result = set_session_without_session_stored(env, sid, session_data)
        if ::Devise.cas_enable_single_sign_out && result && session_data['cas_last_valid_ticket']
          ::DeviseCasAuthenticatable::SingleSignOut::Strategies.current_strategy.store_session_id_for_index(session_data['cas_last_valid_ticket'], sid)
        end

        result
      end

      def destroy_session(sid)
        @pool.del(sid)
      end
    end
  end
end


if ::Redis::Store.rails3?
  ActionDispatch::Session::RedisSessionStore.class_eval do
    include DeviseCasAuthenticatable::SingleSignOut::RedisSessionStore
    alias_method_chain :set_session, :session_stored
  end
else
  ActionController::Session::RedisSessionStore.class_eval do
    include DeviseCasAuthenticatable::SingleSignOut::RedisSessionStore
    alias_method_chain :set_session, :session_stored
  end
end