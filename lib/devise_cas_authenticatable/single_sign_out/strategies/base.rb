module DeviseCasAuthenticatable
  module SingleSignOut
    module Strategies
      class Base
        def logger
          @logger ||= Rails.logger
        end
      end
    end
  end
end