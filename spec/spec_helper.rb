ENV["RAILS_ENV"] = "test"
$:.unshift File.dirname(__FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require "scenario/config/environment"
require 'rspec/rails'
require 'capybara/rspec'
require 'pry'

require 'database_cleaner/active_record'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

# Patching Rack::FakeCAS so that it uses the real, configured service URL as the service param
require 'rack/fake_cas'
class Rack::FakeCAS
  protected

  def login_page
    <<-EOS
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8"/>
    <title>Fake CAS</title>
  </head>
  <body>
    <form action="#{@request.script_name}/login" method="post">
      <input type="hidden" name="service" value="#{RackCAS.config.service}"/>
      <label for="username">Username</label>
      <input id="username" name="username" type="text"/>
      <label for="password">Password</label>
      <input id="password" name="password" type="password"/>
      <input type="submit" value="Login"/>
    </form>
  </body>
</html>
    EOS
  end
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
