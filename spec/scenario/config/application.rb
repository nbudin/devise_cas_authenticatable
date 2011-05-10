require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env) if defined?(Bundler)

require 'castronaut'
class TestAdapter
  def self.reset_valid_users!
    @@valid_users = {
      "joeuser" => "joepassword"
    }
  end
  reset_valid_users!

  def self.register_valid_user(username, password)
    @@valid_users[username] = password
  end
  
  def self.authenticate(username, password)
    error_message = if @@valid_users[username] == password
      nil
    else
      "Invalid password"
    end
    
    Castronaut::AuthenticationResult.new(username, error_message)
  end  
end

Castronaut::Adapters.register("test_adapter", TestAdapter)
Castronaut.config = Castronaut::Configuration.load(File.expand_path(File.join(File.dirname(__FILE__), "castronaut.yml")))

module Scenario
  class Application < Rails::Application
    config.active_support.deprecation = :stderr
  end
end
