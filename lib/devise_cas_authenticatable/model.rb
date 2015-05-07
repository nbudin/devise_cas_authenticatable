module Devise
  module Models
    # Extends your User class with support for CAS ticket authentication.
    module CasAuthenticatable
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        # Authenticate a CAS ticket and return the resulting user object.  Behavior is as follows:
        # 
        # * Check ticket validity using RubyCAS::Client.  Return nil if the ticket is invalid.
        # * Find a matching user by username (will use find_for_authentication if available).
        # * If the user does not exist, but Devise.cas_create_user is set, attempt to create the
        #   user object in the database.  If cas_extra_attributes= is defined, this will also
        #   pass in the ticket's extra_attributes hash.
        # * Return the resulting user object.
        def authenticate_with_cas_ticket(ticket)
          ::Devise.cas_client.validate_service_ticket(ticket) unless ticket.has_been_validated?
          
          if ticket.is_valid?
           condition = nil
           ticket_response = ticket.respond_to?(:user) ? ticket : ticket.response

           if ::Devise.cas_username_field.nil?
              condition = ticket_response.user
           else
              condition = ticket_response.extra_attributes[::Devise.cas_username_field]
           end

           conditions = {::Devise.cas_username_column => condition} 
            # We don't want to override Devise 1.1's find_for_authentication
            resource = if respond_to?(:find_for_authentication)
              find_for_authentication(conditions)
            else
              find(:first, :conditions => conditions)
            end
            
            resource = new(conditions) if (resource.nil? and should_create_cas_users?)
            return nil unless resource
            
            if resource.respond_to? :cas_extra_attributes=
              resource.cas_extra_attributes = ticket_response.extra_attributes
            end
            resource.save
            resource
          end
        end

        private
        def should_create_cas_users?
          respond_to?(:cas_create_user?) ? cas_create_user? : ::Devise.cas_create_user?
        end
      end
    end
  end
end
