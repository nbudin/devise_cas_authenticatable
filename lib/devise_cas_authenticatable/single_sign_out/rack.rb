module DeviseCasAuthenticatable
  module SingleSignOut

    class StoreSessionId
      CAS_TICKET_STORE = 'cas_last_valid_ticket_store'
      CAS_LAST_TICKET  = 'cas_last_valid_ticket'

      def initialize(app)
        @app = app
      end

      def call(env)
        store_session_id_for_cas_ticket(env)
        @app.call(env)
      end

      private
      def store_session_id_for_cas_ticket(env)
        request = Rack::Request.new(env)
        session = request.session

        if session.respond_to?(:id)
          # Rack > 1.5
          session_id = session.id
        else
          # Compatible with old Rack requests
          session_id = env['rack.session.options'][:id]
        end
        cas_ticket_store = session[CAS_TICKET_STORE]

        if cas_ticket_store
          Rails.logger.info "Storing Session ID #{session_id} for ticket #{session[CAS_LAST_TICKET]}"
          ::DeviseCasAuthenticatable::SingleSignOut::Strategies.current_strategy.store_session_id_for_index(session[CAS_LAST_TICKET], session_id)
          session[CAS_TICKET_STORE] = false
        end
      end
    end
  end
end
