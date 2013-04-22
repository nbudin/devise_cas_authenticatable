def cas_login_url
  @cas_login_url ||= begin
    uri = URI.parse(Devise.cas_base_url + "/login")
    uri.query = Rack::Utils.build_nested_query(:service => user_service_url)
    uri.to_s
  end
end

def cas_logout_url
  @cas_logout_url ||= Devise.cas_base_url + "/logout"
end

def sign_into_cas(username, password)
  visit cas_login_url
  fill_in "Username", :with => username
  fill_in "Password", :with => password
  click_on "Login"
  current_url.should == root_url
end