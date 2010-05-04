module Devise
  module Models
    module CasAuthenticatable
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        mattr_reader :cas_extra_attributes_mapping
        @@cas_extra_attributes_mapping = {}
        
        def authenticate_with_cas_ticket(ticket)
          ::Devise.cas_client.validate_service_ticket(ticket) unless ticket.has_been_validated?
          
          if ticket.is_valid?
            conditions = {:username => ticket.response.user}
            puts conditions.inspect
            
            resource = find_for_cas_authentication(conditions)
            resource = new(conditions) if (resource.nil? and ::Devise.cas_create_user)
            return nil unless resource
            
            if resource.new_record?
              @@cas_extra_attributes_mapping.each do |cas_attr, model_attr|
                conditions[model_attr] = ticket.response.extra_attributes[cas_attr]
              end
              
              create(conditions)
            else
              if ::Devise.cas_update_user
                @@cas_extra_attributes_mapping.each do |cas_attr, model_attr|
                  resource.send("#{model_attr}=", ticket.response.extra_attributes[cas_attr])
                end
                resource.save
              end
              
              resource
            end
          end
        end
        
        protected
        def find_for_cas_authentication(conditions)
          find(:first, :conditions => conditions)
        end
      end
    end
  end
end
