require 'devise'

require 'devise_cas_authenticatable/schema'
require 'devise_cas_authenticatable/routes'
require 'devise_cas_authenticatable/strategy'
require 'devise_cas_authenticatable/exceptions'

require 'devise_cas_authenticatable/session_store_identifier'
require 'devise_cas_authenticatable/single_sign_out'

require 'devise_cas_authenticatable/cas_action_url_factory_base'

require 'rubycas-client'

require 'devise_cas_authenticatable/railtie' if defined?(Rails::Railtie)
require 'devise_cas_authenticatable/memcache_checker'

# Register as a Rails engine if Rails::Engine exists
begin
  Rails::Engine
rescue
else
  module DeviseCasAuthenticatable
    class Engine < Rails::Engine
      initializer "devise_cas_authenticatable.single_sign_on.warden_failure_app" do |app|
        # requiring this here because the parent class calls Rails.application, which
        # isn't set up until after bundler has required the modules in this engine
        require 'devise_cas_authenticatable/single_sign_out/warden_failure_app'
      end
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

  # The destination url for logout.
  @@cas_destination_url = nil

  # The follow url for logout.
  @@cas_follow_url = nil

  # Which url to send with logout, destination or follow. Can either be nil, destination or follow.
  @@cas_logout_url_param = nil

  # Should devise_cas_authenticatable enable single-sign-out? Requires use of a supported
  # session_store. Currently supports active_record or redis.
  # False by default.
  @@cas_enable_single_sign_out = false

  # What strategy should single sign out use for tracking token->session ID mapping.
  # :rails_cache by default.
  @@cas_single_sign_out_mapping_strategy = :rails_cache

  # Should devise_cas_authenticatable attempt to create new user records for
  # unknown usernames?  True by default.
  @@cas_create_user = true

  # The model attribute used for query conditions. Should be the same as
  # the rubycas-server username_column. :username by default
  @@cas_username_column = :username

  # The CAS reponse value used to find users in the local database
  # it is required that this field be in cas_extra_attributes
  @@cas_user_identifier = nil

  # Name of the parameter passed in the logout query
  @@cas_destination_logout_param_name = nil

  # Additional options for CAS client object
  @@cas_client_config_options = {}

  mattr_accessor :cas_base_url, :cas_login_url, :cas_logout_url, :cas_validate_url, :cas_destination_url, :cas_follow_url, :cas_logout_url_param, :cas_create_user, :cas_destination_logout_param_name, :cas_username_column, :cas_enable_single_sign_out, :cas_single_sign_out_mapping_strategy, :cas_user_identifier, :cas_client_config_options

  def self.cas_create_user?
    cas_create_user
  end

  # Return a CASClient::Client instance based on configuration parameters.
  def self.cas_client
    @@cas_client ||= begin
      cas_options = {
        :cas_destination_logout_param_name => @@cas_destination_logout_param_name,
        :cas_base_url => @@cas_base_url,
        :login_url => @@cas_login_url,
        :logout_url => @@cas_logout_url,
        :validate_url => @@cas_validate_url,
        :enable_single_sign_out => @@cas_enable_single_sign_out
      }

      cas_options.merge!(@@cas_client_config_options) if @@cas_client_config_options

      CASClient::Client.new(cas_options)
    end
  end

  def self.cas_service_url(base_url, mapping)
    cas_action_url(base_url, mapping, "service")
  end

  def self.cas_unregistered_url(base_url, mapping)
    cas_action_url(base_url, mapping, "unregistered")
  end

  private
  def self.cas_action_url(base_url, mapping, action)
    cas_action_url_factory_class.new(base_url, mapping, action).call
  end

  def self.cas_action_url_factory_class
    @cas_action_url_factory_class ||= CasActionUrlFactoryBase.prepare_class
  end
end

Devise.add_module(:cas_authenticatable,
  :strategy => true,
  :controller => :cas_sessions,
  :route => :cas_authenticatable,
  :model => 'devise_cas_authenticatable/model')
