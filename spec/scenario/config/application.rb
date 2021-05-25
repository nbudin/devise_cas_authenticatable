require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env) if defined?(Bundler)

module Scenario
  class Application < Rails::Application
    config.active_support.deprecation = :stderr
    config.rack_cas.fake = true
  end
end
