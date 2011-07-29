require 'devise/schema'

module Devise
  module Schema
    # Adds the required fields for cas_authenticatable to the schema.  Currently
    # this is just username (String).
    def cas_authenticatable
      if respond_to? :apply_devise_schema
        apply_devise_schema :username, String
        apply_devise_schema :ido_id, String
      else
        apply_schema :username, String
        apply_schema :ido_id, String
      end
    end
  end
end
