# Redirect to the logout url when :warden is thrown,
# so that a single_sign_out request can be initiated
class DeviseCasAuthenticatable::SingleSignOut::WardenFailureApp < Devise::FailureApp

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end

  def redirect
    store_location!
    if flash[:timedout] && flash[:alert]
      flash.keep(:timedout)
      flash.keep(:alert)
    else
      flash[:alert] = i18n_message
    end
    redirect_to redirect_url
  end

  protected

  def redirect_url
    if warden_message == :timeout
      flash[:timedout] = true
      Devise.cas_client.logout_url
    else
      if respond_to?(:scope_path)
        scope_path
      else
        super
      end
    end
  end
  
  # Devise < 2.0 doesn't have this method, which we want to use
  unless instance_methods.include?(:warden_message)
    define_method :warden_message do
      @message ||= warden.message || warden_options[:message]
    end
  end
end