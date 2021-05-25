class Devise::CasSessionsController < Devise::SessionsController
  def new
    # TODO: Figure out if there's a less hacky way to do this
    RackCAS.config.service = cas_service_url
    head 401
  end

  def service
    redirect_to after_sign_in_path_for(warden.authenticate!(:scope => resource_name))
  end

  def unregistered; end

  def destroy
    # if :cas_create_user is false a CAS session might be open but not signed_in
    # in such case we destroy the session here
    if signed_in?(resource_name)
      sign_out(resource_name)
      session.delete('cas')
    else
      reset_session
    end

    redirect_to(cas_logout_url)
  end

  private

  def cas_login_url
    RackCAS::Server.new(RackCAS.config.server_url).login_url(cas_service_url).to_s
  end
  helper_method :cas_login_url

  def request_url
    return @request_url if @request_url

    @request_url = request.protocol.dup
    @request_url << request.host
    @request_url << ":#{request.port}" unless request.port == 80
    @request_url
  end

  def cas_destination_url
    return unless ::Devise.cas_logout_url_param == 'destination'

    if !::Devise.cas_destination_url.blank?
      Devise.cas_destination_url
    else
      url = request_url.dup
      url << after_sign_out_path_for(resource_name)
    end
  end

  def cas_follow_url
    return unless ::Devise.cas_logout_url_param == 'follow'

    if !::Devise.cas_follow_url.blank?
      Devise.cas_follow_url
    else
      url = request_url.dup
      url << after_sign_out_path_for(resource_name)
    end
  end

  def cas_service_url
    ::Devise.cas_service_url(request_url.dup, devise_mapping)
  end

  def cas_logout_url
    server = RackCAS::Server.new(RackCAS.config.server_url)
    destination_url = cas_destination_url
    follow_url = cas_follow_url
    service_url = cas_service_url

    if destination_url
      server.logout_url(destination: destination_url, gateway: 'true').to_s
    elsif follow_url
      server.logout_url(url: follow_url, service: service_url).to_s
    else
      server.logout_url(service: service_url).to_s
    end
  end
end
