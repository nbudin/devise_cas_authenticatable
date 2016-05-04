module DeviseCasAuthenticatable
  class SessionStoreIdentifier

    def current_session_store
      app = Rails.application.app
      begin
        app = (app.instance_variable_get(:@backend) || app.instance_variable_get(:@app) || app.instance_variable_get(:@target))
      end until app.nil? or app.class == session_store_class
      app
    end

    def session_store_class
      @session_store_class ||=
        begin
          # Rails 3 & 4 session store
          if ::DeviseCasAuthenticatable::SingleSignOut.rails3_or_greater?
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
  end
end