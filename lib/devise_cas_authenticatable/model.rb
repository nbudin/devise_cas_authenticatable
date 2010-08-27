module Devise
  module Models
    module CasAuthenticatable
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        def authenticate_with_cas_ticket(ticket)
          ::Devise.cas_client.validate_service_ticket(ticket) unless ticket.has_been_validated?
          
          if ticket.is_valid?
            conditions = {:username => ticket.response.user}
            puts conditions.inspect
            
            resource = find_for_authentication(conditions)
            resource = new(conditions) if (resource.nil? and ::Devise.cas_create_user)
            return nil unless resource
            
            if resource.new_record?
              if resource.respond_to? :cas_extra_attributes=
                resource.cas_extra_attributes = ticket.response.extra_attributes
              end
              
              create(conditions)
            else
              if resource.respond_to? :cas_extra_attributes=
                resource.cas_extra_attributes = ticket.response.extra_attributes
                resource.save
              end
              
              resource
            end
          end
        end
      end
    end
  end
end
