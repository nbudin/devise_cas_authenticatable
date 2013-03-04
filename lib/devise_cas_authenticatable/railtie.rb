require 'devise_cas_authenticatable'
require 'rails'

module DeviseCasAuthenticatable
  class Railtie < ::Rails::Railtie
    initializer "devise_cas_authenticatable.use_rack_middleware" do |app|
      app.config.middleware.use "DeviseCasAuthenticatable::SingleSignOut::StoreSessionId"
    end
  end
end
