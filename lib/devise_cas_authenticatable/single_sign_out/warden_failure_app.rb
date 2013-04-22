# Redirect to the logout url when :warden is thrown,
# so that a single_sign_out request can be initiated
class DeviseCasAuthenticatable::SingleSignOut::WardenFailureApp < Devise::FailureApp

  alias :standard_scope_path :scope_path

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
      scope_path
    end
  end

  def scope_path
    standard_scope_path
  end
    
end