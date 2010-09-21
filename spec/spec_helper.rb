ENV["RAILS_ENV"] = "test"
$:.unshift File.dirname(__FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require "scenario/config/environment"
require "rails/test_help"
require 'rspec/rails'
require 'sham_rack'

Webrat.configure do |config|
  config.mode = :rails
  config.open_error_files = false
end

RSpec.configure do |config| 
  config.mock_with :mocha 
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }