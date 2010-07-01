class Devise::CasSessionsController < ApplicationController
  prepend_before_filter :require_no_authentication, :only => [:login]
  include Devise::Controllers::InternalHelpers
  
  def service
    if signed_in?(resource_name)
      redirect_to after_sign_in_path_for(resource_name)
    else
      redirect_to root_url
    end
  end
  
  def destroy
    sign_out(resource_name)
    destination = request.protocol
    destination << request.host
    destination << ":#{request.port.to_s}" unless request.port == 80
    destination << after_sign_out_path_for(resource_name)
    redirect_to(::Devise.cas_client.logout_url(destination))
  end
end