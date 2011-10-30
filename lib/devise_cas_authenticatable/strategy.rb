require 'devise/strategies/base'
require 'net/http'
require 'uri'

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
        
        #
        #Check if there is an invite token
        #
        invite_token = params[:bushido_invite_token]
        unless invite_token.nil?
          puts "lets hit the invite proxy"
          puts ::Devise.cas_login_url
          uri = URI.parse(::Devise.cas_login_url)
          http = Net::HTTP.new(uri.host, uri.port)
          request = Net::HTTP::Post.new(uri.request_uri)
          request.set_form_data({:invitation_token => invite_token})
          response = http.request(request)
          puts "OMG A RESPONES?"
          puts response.inspect
        end
        
        ticket = read_ticket(params)
        if ticket
          if resource = mapping.to.authenticate_with_cas_ticket(ticket)
            success!(resource)
          elsif ticket.is_valid?
              logger.debug "="*30
              logger.debug ticket.response.user[:ido_id]
              logger.debug "="*30
            redirect!(::Devise.cas_unregistered_url(request.url, mapping), :ido_id => ticket.response.user)
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

Warden::Strategies.add(:bushido_authenticatable, Devise::Strategies::CasAuthenticatable)
