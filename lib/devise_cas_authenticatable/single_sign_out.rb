module DeviseCasAuthenticatable
  module SingleSignOut

    def self.rails3_or_greater?
      defined?(::Rails) && ::Rails::VERSION::MAJOR >= 3
    end

    # Supports destroying sessions by ID for ActiveRecord and Redis session stores
    module DestroySession
      def destroy_session_by_id(sid)
        logger.debug "Single Sign Out from session store: #{current_session_store.class}"

        if session_store_class.name =~ /ActiveRecord::SessionStore/
          session = session_store_class::Session.find_by_session_id(sid)
          session.destroy if session
          true
        elsif session_store_class.name =~ /ActionDispatch::Session::ActiveRecordStore/
          session = current_session_store.session_class.find_by_session_id(sid)
          session.destroy if session
          true
        elsif session_store_class.name =~ /ActionDispatch::Session::DalliStore/
          current_session_store.send(:destroy_session, env, sid, drop: true)
          true
        elsif session_store_class.name =~ /RedisSessionStore/
          current_session_store.send(:destroy_session, env, sid, drop: true)
          true
        elsif session_store_class.name =~ /Redis/
          current_session_store.instance_variable_get(:@pool).del(sid)
          true
        elsif session_store_class.name =~ /CacheStore/
          if current_session_store.respond_to?(:delete_session)  # Rails 5 and up
            current_session_store.delete_session({}, sid, {})
          else
            current_session_store.destroy_session({}, sid, {})
          end

          true
        else
          logger.error "Cannot process logout request because this Rails application's session store is "+
                " #{session_store_class.name} and is not a support session store type for Single Sign-Out."
          false
        end
      end

      def session_store_identifier
        @session_store_identifier ||= DeviseCasAuthenticatable::SessionStoreIdentifier.new
      end

      def current_session_store
        session_store_identifier.current_session_store
      end

      def session_store_class
        session_store_identifier.session_store_class
      end
    end

  end
end

require 'devise_cas_authenticatable/single_sign_out/strategies'
require 'devise_cas_authenticatable/single_sign_out/strategies/base'
require 'devise_cas_authenticatable/single_sign_out/strategies/rails_cache'
require 'devise_cas_authenticatable/single_sign_out/strategies/redis_cache'
require 'devise_cas_authenticatable/single_sign_out/rack'
