require 'devise/schema'

module Devise
  module Schema
    def cas_authenticatable
      apply_schema :username, String
    end
  end
end