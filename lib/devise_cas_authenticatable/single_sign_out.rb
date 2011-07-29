require 'devise_cas_authenticatable/single_sign_out/session_store/redis'
require 'devise_cas_authenticatable/single_sign_out/strategies'
require 'devise_cas_authenticatable/single_sign_out/strategies/base'
require 'devise_cas_authenticatable/single_sign_out/strategies/rails_cache'

# Need to make a small extension to rails to expose the session_store to our controllers
require 'action_dispatch/middleware/session/abstract_store'
ActionDispatch::Session::AbstractStore.class_eval do
  def prepare_with_session_store!(env)
    prepare_without_session_store!(env)
    env[:session_store] = self
  end
  alias_method_chain :prepare!, :session_store
end