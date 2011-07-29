module DeviseCasAuthenticatable
  module SingleSignOut
    module Strategies
      class << self

        # Add a strategy and store it in a hash.
        def add(label, strategy, &block)
          strategy ||= Class.new(DeviseCasAuthenticatable::SingleSignOut::Strategies::Base)
          strategy.class_eval(&block) if block_given?

          check_method(label, strategy, :store_session_id_for_index)
          check_method(label, strategy, :find_session_id_by_index)
          check_method(label, strategy, :delete_session_index)

          unless strategy.ancestors.include?(DeviseCasAuthenticatable::SingleSignOut::Strategies::Base)
            raise "#{label.inspect} is not a #{base}"
          end

          _strategies[label] = strategy.new()
        end

        # Update a previously given strategy.
        def update(label, &block)
          strategy = _strategies[label]
          raise "Unknown strategy #{label.inspect}" unless strategy
          add(label, strategy, &block)
        end

        # Provides access to strategies by label
        def [](label)
          _strategies[label]
        end

        def current_strategy
          self[::Devise.cas_single_sign_out_mapping_strategy]
        end

        # Clears all declared.
        def clear!
          _strategies.clear
        end

        private

        def _strategies
          @strategies ||= {}
        end

        def check_method(label, strategy, method)
          unless strategy.method_defined?(method)
            raise NoMethodError, "#{method.to_s} is not declared in the #{label.inspect} strategy"
          end
        end

      end
    end
  end
end