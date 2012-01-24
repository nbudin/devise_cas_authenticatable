module DeviseCasAuthenticatable
  module SingleSignOut
    module Strategies
      class RailsCache < Base
          def store_session_id_for_index(session_index, session_id)
            logger.debug("Storing #{session_id} for index #{session_index}")
            Rails.cache.write(cache_key(session_index), session_id)
          end

          def find_session_id_by_index(session_index)
            sid = Rails.cache.read(cache_key(session_index))
            logger.debug("Found session id #{sid} for index #{session_index}")
            sid
          end

          def delete_session_index(session_index)
            logger.debug("Deleting index #{session_index}")
            Rails.cache.delete(cache_key(session_index))
          end

          private

          def cache_key(session_index)
            "devise_cas_authenticatable:#{session_index}"
          end
      end
    end
  end
end

::DeviseCasAuthenticatable::SingleSignOut::Strategies.add( :rails_cache, DeviseCasAuthenticatable::SingleSignOut::Strategies::RailsCache )
