ActionDispatch::Routing::Mapper.class_eval do
  protected

  def devise_cas_authenticatable(mapping, controllers)
    sign_out_via = (Devise.respond_to?(:sign_out_via) && Devise.sign_out_via) || [:get, :post]

    # service endpoint for CAS server
    get 'service', to: "#{controllers[:cas_sessions]}#service", as: 'service'

    resource :session, only: [], controller: controllers[:cas_sessions], path: '' do
      get :new, path: mapping.path_names[:sign_in], as: 'new'
      get :unregistered
      post :create, path: mapping.path_names[:sign_in]
      match :destroy, path: mapping.path_names[:sign_out], as: 'destroy', via: sign_out_via
    end
  end

  def raise_no_secret_key #:nodoc:
    # Devise_cas_authenticatable does not store passwords, so does not need a secret!
    Rails.logger.warn <<~WARNING
      Devise_cas_authenticatable has suppressed an exception from being raised for missing Devise.secret_key.
      If devise_cas_authenticatable is the only devise module you are using for authentication you can safely ignore this warning.
      However, if you use another module that requires the secret_key please follow these instructions from Devise:

      Devise.secret_key was not set. Please add the following to your Devise initializer:

          config.secret_key = '#{SecureRandom.hex(64)}'

      Please ensure you restarted your application after installing Devise or setting the key.
    WARNING
  end
end

