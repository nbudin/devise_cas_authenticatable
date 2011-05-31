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
            success!(resource)
          elsif ticket.is_valid?
            redirect!(::Devise.cas_unregistered_url(request.url, mapping), :username => ticket.response.user)
            #fail!("The user #{ticket.response.user} is not registered with this site.  Please use a different account.")
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
