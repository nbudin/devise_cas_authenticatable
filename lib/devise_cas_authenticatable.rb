require 'devise'

require 'devise_cas_authenticatable/schema'
require 'devise_cas_authenticatable/routes'
require 'devise_cas_authenticatable/strategy'
require 'devise_cas_authenticatable/exceptions'

require 'rubycas-client'

# Register as a Rails engine if Rails::Engine exists
begin
  Rails::Engine
rescue
else
  module DeviseCasAuthenticatable
    class Engine < Rails::Engine
    end
  end
end

module Devise
  # The base URL of the CAS server.  For example, http://cas.example.com.  Specifying this
  # is mandatory.
  @@cas_base_url = nil

  # The login URL of the CAS server.  If undefined, will default based on cas_base_url.
  @@cas_login_url = nil

  # The login URL of the CAS server.  If undefined, will default based on cas_base_url.
  @@cas_logout_url = nil

  # The login URL of the CAS server.  If undefined, will default based on cas_base_url.
  @@cas_validate_url = nil

  # Should devise_cas_authenticatable attempt to create new user records for
  # unknown usernames?  True by default.
  @@cas_create_user = true

  # The model attribute used for query conditions. Should be the same as
  # the rubycas-server username_column. :username by default
  @@cas_username_column = :ido_id

  # Name of the parameter passed in the logout query
  @@cas_destination_logout_param_name = nil

  mattr_accessor :cas_base_url, :cas_login_url, :cas_logout_url, :cas_validate_url, :cas_create_user, :cas_destination_logout_param_name, :cas_username_column

  def self.cas_create_user?
    cas_create_user
  end

  # Return a CASClient::Client instance based on configuration parameters.
  def self.cas_client
    @@cas_client ||= CASClient::Client.new(
        :cas_destination_logout_param_name => @@cas_destination_logout_param_name,
        :cas_base_url => @@cas_base_url,
        :login_url => @@cas_login_url,
        :logout_url => @@cas_logout_url,
        :validate_url => @@cas_validate_url
      )
  end

  def self.cas_service_url(base_url, mapping)
    cas_action_url(base_url, mapping, "service")
  end

  def self.cas_unregistered_url(base_url, mapping)
    cas_action_url(base_url, mapping, "unregistered")
  end

  private
  def self.cas_action_url(base_url, mapping, action)
    u = URI.parse(base_url)
    u.query = nil
    u.path = if mapping.respond_to?(:fullpath)
        mapping.fullpath
      else
        mapping.raw_path
      end
    u.path << "/"
    u.path << action
    u.to_s

    return u.to_s
  end

end

Devise.add_module(:bushido_authenticatable,
  :strategy => true,
  :controller => :cas_sessions,
  :route => :bushido_authenticatable,
  :model => 'devise_cas_authenticatable/model')
