require File.expand_path(File.dirname(__FILE__)) + '/devise_cas_authenticatable'

module Devise
  def self.on_bushido?
    return false if ENV['BUSHIDO_APP_KEY'].nil?
    true
  end
end
