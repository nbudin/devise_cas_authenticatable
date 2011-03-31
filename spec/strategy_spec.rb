require 'spec_helper'

describe Devise::Strategies::CasAuthenticatable, :type => "acceptance" do
  include Rspec::Rails::RequestExampleGroup
  
  before do    
    Devise.cas_base_url = "http://www.example.com/cas_server"
    TestAuthenticator.reset_valid_users!
    User.create! do |u|
      u.username = "joeuser"
    end
  end
  
  after do
    User.delete_all
  end
  
  def cas_login_url
    @cas_login_url ||= begin
      uri = URI.parse(Devise.cas_base_url + "/login")
      uri.query = Rack::Utils.build_nested_query(:service => user_url)
      uri.to_s
    end
  end
  
  describe "GET /protected/resource" do
    before { get '/' }

    it 'should redirect to sign-in' do
      response.should be_redirect
      response.should redirect_to(cas_login_url)
    end
  end
  
  describe "Sign in with valid user" do
    it 'should log in ok' do
      puts cas_login_url
      visit cas_login_url
      puts Capybara.current_session.current_url
      save_and_open_page
    end
  end
end