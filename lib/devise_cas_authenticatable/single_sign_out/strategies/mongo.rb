module DeviseCasAuthenticatable
  module SingleSignOut
    module Strategies
      class Mongo < Base
          def store_session_id_for_index(session_index, session_id)
            logger.debug("Storing #{session_id} for index #{session_index} in mongo")
            MongoCasSession.create(cas_session_index: session_index, session_id: session_id)
          end

          def find_session_id_by_index(session_index)
            sid = MongoCasSession.find_by(cas_session_index: session_index).session_id
            logger.debug("Found session id #{sid} for index #{session_index} in mongo")
            sid
          end

          def delete_session_index(session_index)
            logger.debug("Deleting index #{session_index} in mongo")
            # TCT: Not sure if more than one register was created, so deleting them all
            MongoCasSession.where(cas_session_index: session_index).destroy_all
          end

          private
      end
    end
  end
end

::DeviseCasAuthenticatable::SingleSignOut::Strategies.add( :mongo, DeviseCasAuthenticatable::SingleSignOut::Strategies::Mongo )