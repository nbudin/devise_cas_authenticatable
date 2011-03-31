require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env) if defined?(Bundler)

require "devise"
require "devise_cas_authenticatable"

Devise.setup do |config|
  require "devise/orm/active_record"
end

require 'casserver/authenticators/base'
class TestAuthenticator < CASServer::Authenticators::Base
  def self.reset_valid_users!
    @@valid_users = {
      "joeuser" => "joepassword"
    }
  end
  reset_valid_users!

  def self.register_valid_user(username, password)
    @@valid_users[username] = password
  end
  
  def validate(credentials)
    @@valid_users[credentials[:username]] == credentials[:password]
  end  
end

module Scenario
  class Application < Rails::Application
    config.active_support.deprecation = :stderr
  end
end
