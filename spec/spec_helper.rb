ENV["RAILS_ENV"] = "test"
$:.unshift File.dirname(__FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require "scenario/config/environment"
require "rails/test_help"
require 'rspec/rails'
require 'sham_rack'
require 'capybara/rspec'

RSpec.configure do |config| 
  config.mock_with :mocha 
end

ShamRack.at('www.example.com') do |env|
  request = Rack::Request.new(env)
  request.path_info = request.path_info.sub(/^\/cas_server/, '')
  
  Castronaut::Application.call(request.env)
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }