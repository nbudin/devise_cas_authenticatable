module DeviseCasAuthenticatable
  module SingleSignOut
    module Strategies
      class Mongo < Base
          def store_session_id_for_index(session_index, session_id)
            logger.debug("Storing #{session_id} for index #{session_index}")
            CasSession.create(cas_session_index: session_index, session_id: session_id)
          end

          def find_session_id_by_index(session_index)
            sid = CasSession.find_by(cas_session_index: session_index).session_id
            logger.debug("Found session id #{sid} for index #{session_index}")
            sid
          end

          def delete_session_index(session_index)
            logger.debug("Deleting index #{session_index}")
            # TCT: Not sure if more than one regiter was created, so deleting them all
            CasSession.where(cas_session_index: session_index).destroy_all
          end

          private

          def cache_key(session_index)
            "devise_cas_authenticatable:#{session_index}"
          end
      end
    end
  end
end

::DeviseCasAuthenticatable::SingleSignOut::Strategies.add( :mongo, DeviseCasAuthenticatable::SingleSignOut::Strategies::Mongo )