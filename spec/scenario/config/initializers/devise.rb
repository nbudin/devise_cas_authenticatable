Devise.setup do |config|
  require "devise/orm/active_record"
  config.timeout_in = 7200
end