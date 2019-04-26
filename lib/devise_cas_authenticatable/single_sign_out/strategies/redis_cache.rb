require 'devise_cas_authenticatable/single_sign_out/with_conn'

module DeviseCasAuthenticatable
  module SingleSignOut
    module Strategies
      class RedisCache < Base
        include ::DeviseCasAuthenticatable::SingleSignOut::DestroySession
        include ::DeviseCasAuthenticatable::SingleSignOut::WithConn

        def store_session_id_for_index(session_index, session_id)
          logger.debug("Storing #{session_id} for index #{session_index}")
          with_conn do |conn|
            conn.set(
              cache_key(session_index),
              session_id
            )
          end
        end
        def find_session_id_by_index(session_index)
          sid = with_conn { |conn| conn.get(cache_key(session_index)) }
          logger.debug("Found session id #{sid} for index #{session_index}") if sid
          sid
        end
        def delete_session_index(session_index)
          logger.debug("Deleting index #{session_index}")
          destroy_session_by_id(session_index)
        end

        private
        def cache_key(session_index)
          "devise_cas_authenticatable:#{session_index}"
        end
      end
    end
  end
end

::DeviseCasAuthenticatable::SingleSignOut::Strategies.add(:redis_cache, DeviseCasAuthenticatable::SingleSignOut::Strategies::RedisCache )
