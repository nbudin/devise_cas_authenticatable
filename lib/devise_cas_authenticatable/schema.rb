require 'devise/schema'

module Devise
  module Schema
    def bushido_authenticatable
      if respond_to? :apply_devise_schema
        apply_devise_schema :ido_id, String
      else
        apply_schema :ido_id, String
      end
    end
  end
end
