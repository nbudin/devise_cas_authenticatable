require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env) if defined?(Bundler)

require 'cassy'

class TestAdapter < Cassy::Authenticators::Base
  def self.reset_valid_users!
    @@valid_users = {
      "joeuser" => "joepassword"
    }
  end
  reset_valid_users!

  def self.register_valid_user(username, password)
    @@valid_users[username] = password
  end
  
  def self.find_user(credentials)
    if @@valid_users[credentials[:username]] == credentials[:password]
      credentials[:username]
    else
      nil
    end
  end  
end

module Scenario
  class Application < Rails::Application
    config.active_support.deprecation = :stderr
  end
end
