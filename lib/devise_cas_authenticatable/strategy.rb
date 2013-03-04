require 'devise/strategies/base'

module Devise
  module Strategies
    class CasAuthenticatable < Base
      # True if the mapping supports authenticate_with_cas_ticket.
      def valid?
        mapping.to.respond_to?(:authenticate_with_cas_ticket) && params[:ticket]
      end
      
      # Try to authenticate a user using the CAS ticket passed in params.
      # If the ticket is valid and the model's authenticate_with_cas_ticket method
      # returns a user, then return success.  If the ticket is invalid, then either
      # fail (if we're just returning from the CAS server, based on the referrer)
      # or attempt to redirect to the CAS server's login URL.
      def authenticate!
        ticket = read_ticket(params)
        if ticket
          if resource = mapping.to.authenticate_with_cas_ticket(ticket)
            # Store the ticket in the session for later usage
            if ::Devise.cas_enable_single_sign_out
              session['cas_last_valid_ticket'] = ticket.ticket
              session['cas_last_valid_ticket_store'] = true
            end

            success!(resource)
          elsif ticket.is_valid?
            username = ticket.respond_to?(:user) ? ticket.user : ticket.response.user
            redirect!(::Devise.cas_unregistered_url(request.url, mapping), :username => username)
          else
            fail!(:invalid)
          end
        else
          fail!(:invalid)
        end
      end
      
      protected
      
      def read_ticket(params)
        ticket = params[:ticket]
        return nil unless ticket
        
        service_url = ::Devise.cas_service_url(request.url, mapping)
        if ticket =~ /^PT-/
          ::CASClient::ProxyTicket.new(ticket, service_url, params[:renew])
        else
          ::CASClient::ServiceTicket.new(ticket, service_url, params[:renew])
        end
      end
    end
  end
end

Warden::Strategies.add(:cas_authenticatable, Devise::Strategies::CasAuthenticatable)
