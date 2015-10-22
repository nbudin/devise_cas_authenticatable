class CasSession
  include Mongoid::Document
  include Mongoid::Timestamps
  field :cas_session_index, type: String
  field :session_id, type: String
end