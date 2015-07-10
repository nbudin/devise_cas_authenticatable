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

            identifier = extract_user_identifier(ticket_response)

            # If cas_user_identifier isn't in extra_attributes,
            # or the value is blank, then we're done here
            return log_and_exit if identifier.nil?

            logger.debug("Using conditions {#{::Devise.cas_username_column} => #{identifier}} to find the User")

            conditions = { ::Devise.cas_username_column => identifier }
            resource = find_or_build_resource_from_conditions(conditions)
            return nil unless resource
            
            resource.cas_extra_attributes = ticket_response.extra_attributes \
              if resource.respond_to?(:cas_extra_attributes=)

            resource.save
            resource
          end
        end

        private
        def should_create_cas_users?
          respond_to?(:cas_create_user?) ? cas_create_user? : ::Devise.cas_create_user?
        end

        def extract_user_identifier(response)
          return response.user if ::Devise.cas_user_identifier.blank?
          response.extra_attributes[::Devise.cas_user_identifier]
        end

        def log_and_exit
          logger.warn("Could not find a value for [#{::Devise.cas_user_identifier}] in cas_extra_attributes so we cannot find the User.")
          logger.warn("Make sure config.cas_user_identifier is set to a field that appears in cas_extra_attributes")
          return nil
        end

        def find_or_build_resource_from_conditions(conditions)
          resource = find_resource_with_conditions(conditions)
          resource = new(conditions) if (resource.nil? and should_create_cas_users?)
          return resource
        end

        def find_resource_with_conditions(conditions)
          # We don't want to override Devise 1.1's find_for_authentication
          return find_for_authentication(conditions) if respond_to?(:find_for_authentication)
          find(:first, :conditions => conditions)
        end
      end
    end
  end
end
