require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env) if defined?(Bundler)

require "devise"
require "devise_cas_authenticatable"

Devise.setup do |config|
  require "devise/orm/active_record"
end

module Scenario
  class Application < Rails::Application
    config.active_support.deprecation = :stderr
  end
end
