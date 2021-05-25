require 'devise/strategies/base'

module Devise
  module Strategies
    class CasAuthenticatable < Base
      # True if the mapping supports authenticate_with_cas_ticket.
      def valid?
        request = Rack::Request.new(env)
        mapping.to.respond_to?(:authenticate_with_cas_details) && request.session['cas']
      end

      # Try to authenticate a user using the CAS ticket passed in params.
      # If the ticket is valid and the model's authenticate_with_cas_ticket method
      # returns a user, then return success.  If the ticket is invalid, then either
      # fail (if we're just returning from the CAS server, based on the referrer)
      # or attempt to redirect to the CAS server's login URL.
      def authenticate!
        request = Rack::Request.new(env)
        cas_details = request.session['cas']
        if cas_details
          resource = mapping.to.authenticate_with_cas_details(cas_details)
          if resource
            # Store the ticket in the session for later usage
            if ::Devise.cas_enable_single_sign_out
              session['cas_last_valid_ticket'] = ticket.ticket
              session['cas_last_valid_ticket_store'] = true
            end

            success!(resource)
          else
            username = cas_details['user']
            redirect!(::Devise.cas_unregistered_url(request.url, mapping), :username => username)
          end
        else
          # Throw to rack-cas to initiate a login
          rack_cas_authenticate_response = Rack::Response.new(nil, 401)
          custom!(rack_cas_authenticate_response.to_a)
          throw :warden
        end
      end
    end
  end
end

Warden::Strategies.add(:cas_authenticatable, Devise::Strategies::CasAuthenticatable)
