require 'devise/strategies/base'

module Devise
  module Strategies
    class CasAuthenticatable < Base
      def valid?
        mapping.to.respond_to?(:authenticate_with_cas_ticket)
      end
      
      def authenticate!
        ticket = read_ticket(params)
        RAILS_DEFAULT_LOGGER.debug "Received CAS ticket: #{ticket.inspect}"
        if ticket
          if resource = mapping.to.authenticate_with_cas_ticket(ticket)
            success!(resource)
          else
            fail(:invalid)
          end
        elsif returning_from_cas?
          fail(:invalid)
        else
          redirect!(login_url)
        end
      end
      
      protected
      def returning_from_cas?
        request.referer =~ /^#{::Devise.cas_client.cas_base_url}/
      end
      
      def service_url
        url = URI.parse(request.url)
        url.path = "#{mapping.parsed_path}/#{mapping.path_names[:sign_in]}"
        url.query = nil
        url.to_s
      end
      
      def login_url
        ::Devise.cas_client.add_service_to_login_url(service_url)
      end
  
      def read_ticket(params)
        ticket = params[:ticket]
        return nil unless ticket
      
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
