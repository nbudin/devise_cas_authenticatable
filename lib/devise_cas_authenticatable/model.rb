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
            identifier = nil
            ticket_response = ticket.respond_to?(:user) ? ticket : ticket.response

            if ::Devise.cas_user_identifier.blank?
              identifier = ticket_response.user
            else
              identifier = ticket_response.extra_attributes[::Devise.cas_user_identifier]
            end

            # If cas_user_identifier isn't in extra_attributes, or the value is blank, then we're done here
            if identifier.nil?
              logger.warn("Could not find a value for [#{::Devise.cas_user_identifier}] in cas_extra_attributes so we cannot find the User.")
              logger.warn("Make sure config.cas_user_identifier is set to a field that appears in cas_extra_attributes")
              return nil 
            end

            logger.debug("Using conditions {#{::Devise.cas_username_column} => #{identifier}} to find the User")
            conditions = {::Devise.cas_username_column => identifier} 
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
