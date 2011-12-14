module Devise
  module Models
    # Extends your User class with support for CAS ticket authentication.
    module BushidoAuthenticatable
      def self.included(base)
        base.extend ClassMethods

        if defined?(Mongoid)
          base.class_eval do
            field :ido_id  # TODO check with someone who's using Mongoid
          end
        end
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

          puts "ticket = #{ticket.inspect}"

          if ticket.is_valid?
            conditions = {::Devise.cas_username_column => ticket.respond_to?(:user) ? ticket.user : ticket.response.user}
            # We don't want to override Devise 1.1's find_for_authentication
            resource = if respond_to?(:find_for_authentication)
              find_for_authentication(conditions)
            else
              find(:first, :conditions => conditions)
            end

            resource = new(conditions) if (resource.nil? and ::Devise.cas_create_user?)

            puts "found #{resource.inspect}"

            return nil unless resource

            if resource.respond_to? :bushido_extra_attributes=
              resource.bushido_extra_attributes = ticket.respond_to?(:extra_attributes) ? ticket.extra_attributes : ticket.response.extra_attributes
            end

            resource.save
            resource
          end
        end
      end
    end
  end
end
