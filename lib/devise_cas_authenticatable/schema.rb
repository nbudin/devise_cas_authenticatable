require 'devise/schema'

module Devise
  module Schema
    def cas_authenticatable
      if respond_to?(:apply_devise_schema)
        apply_devise_schema :username, String
      else
        apply_schema :username, String
      end
    end
  end
end
