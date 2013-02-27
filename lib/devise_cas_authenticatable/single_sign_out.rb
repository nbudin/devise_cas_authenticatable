module DeviseCasAuthenticatable
  module SingleSignOut

    def self.rails3?
      defined?(::Rails) && ::Rails::VERSION::MAJOR == 3
    end

    # Supports destroying sessions by ID for ActiveRecord and Redis session stores
    module DestroySession
      def session_store_class
        @session_store_class ||=
          begin
            if ::DeviseCasAuthenticatable::SingleSignOut.rails3?
              # => Rails 3
              Rails.configuration.session_store
              ::Rails.application.config.session_store
            else
              # => Rails 2
              ActionController::Base.session_store
            end
          rescue NameError => e
            # for older versions of Rails (prior to 2.3)
            ActionController::Base.session_options[:database_manager]
          end
      end

      def current_session_store
        app = Rails.application.app
        begin
          app = (app.instance_variable_get(:@backend) || app.instance_variable_get(:@app))
        end until app.nil? or app.class == session_store_class
        app
      end

      def destroy_session_by_id(sid)
        logger.debug "Single Sign Out from session store: #{current_session_store.inspect}"

        if session_store_class.name =~ /ActiveRecord::SessionStore/
          session = session_store_class::Session.find_by_session_id(sid)
          session.destroy if session
          true
        elsif session_store_class.name =~ /Redis/
          current_session_store.instance_variable_get(:@pool).del(sid)
          true
        elsif session_store_class.name =~ /CacheStore/
          current_session_store.destroy_session({}, sid, {})
          true
        else
          logger.error "Cannot process logout request because this Rails application's session store is "+
                " #{current_session_store.name.inspect} and is not a support session store type for Single Sign-Out."
          false
        end
      end
    end

  end
end

require 'devise_cas_authenticatable/single_sign_out/strategies'
require 'devise_cas_authenticatable/single_sign_out/strategies/base'
require 'devise_cas_authenticatable/single_sign_out/strategies/rails_cache'
require 'devise_cas_authenticatable/single_sign_out/rack'
