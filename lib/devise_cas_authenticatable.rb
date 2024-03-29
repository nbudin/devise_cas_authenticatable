require 'devise'
require 'rack-cas'
require 'rack-cas/server'

require 'devise_cas_authenticatable/routes'
require 'devise_cas_authenticatable/strategy'
require 'devise_cas_authenticatable/cas_action_url_factory_base'

module DeviseCasAuthenticatable
  class Engine < Rails::Engine ; end
end

module Devise
  # The destination url for logout.
  @@cas_destination_url = nil

  # The follow url for logout.
  @@cas_follow_url = nil

  # Which url to send with logout, destination or follow. Can either be nil, destination or follow.
  @@cas_logout_url_param = nil

  # Should devise_cas_authenticatable attempt to create new user records for
  # unknown usernames?  True by default.
  @@cas_create_user = true

  # The model attribute used for query conditions. :username by default
  @@cas_username_column = :username

  # The CAS reponse value used to find users in the local database
  # it is required that this field be in cas_extra_attributes
  @@cas_user_identifier = nil

  # Name of the parameter passed in the logout query
  @@cas_destination_logout_param_name = nil

  mattr_accessor :cas_destination_url, :cas_follow_url, :cas_logout_url_param, :cas_create_user, :cas_destination_logout_param_name, :cas_username_column, :cas_user_identifier

  def self.cas_create_user?
    cas_create_user
  end

  def self.cas_service_url(base_url, mapping)
    cas_action_url(base_url, mapping, 'service')
  end

  def self.cas_unregistered_url(base_url, mapping)
    cas_action_url(base_url, mapping, 'unregistered')
  end

  def self.cas_action_url(base_url, mapping, action)
    cas_action_url_factory_class.new(base_url, mapping, action).call
  end

  def self.cas_action_url_factory_class
    @cas_action_url_factory_class ||= CasActionUrlFactoryBase.prepare_class
  end

  def self.cas_enable_single_sign_out=(_value)
    puts "Devise.cas_enable_single_sign_out is deprecated as of devise_cas_authenticatable 2.0, and has no effect."
    puts "Single sign out is now handled via rack-cas.  To set it up, see the rack-cas readme:"
    puts "https://github.com/biola/rack-cas#single-logout"
  end

  def self.cas_single_sign_out_mapping_strategy=(_value)
    puts "Devise.cas_single_sign_out_mapping_strategy is deprecated as of devise_cas_authenticatable 2.0, and has no effect."
    puts "Single sign out is now handled via rack-cas.  To set it up, see the rack-cas readme:"
    puts "https://github.com/biola/rack-cas#single-logout"
  end
end

Devise.add_module(
  :cas_authenticatable,
  strategy: true,
  controller: :cas_sessions,
  route: :cas_authenticatable,
  model: 'devise_cas_authenticatable/model'
)
