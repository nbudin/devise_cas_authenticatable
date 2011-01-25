class Devise::CasSessionsController < Devise::SessionsController  
  unloadable
  
  def service
    if signed_in?(resource_name)
      redirect_to after_sign_in_path_for(resource_name)
    else
      redirect_to root_url
    end
  end
  
  def destroy
    # if :cas_create_user is false a CAS session might be open but not signed_in
    # in such case we destroy the session here
    if signed_in?(resource_name)
      sign_out(resource_name)
    else
      reset_session
    end
    destination = request.protocol
    destination << request.host
    destination << ":#{request.port.to_s}" unless request.port == 80
    destination << after_sign_out_path_for(resource_name)
    redirect_to(::Devise.cas_client.logout_url(destination))
  end
end