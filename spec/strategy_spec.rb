require 'spec_helper'

describe Devise::Strategies::CasAuthenticatable, :type => "acceptance" do
  include RSpec::Rails::RequestExampleGroup
  include Capybara::DSL
  
  before do    
    Devise.cas_base_url = "http://www.example.com/cas_server"
    TestAdapter.reset_valid_users!

    User.delete_all
    User.create! do |u|
      u.username = "joeuser"
    end
  end
  
  after do
    visit destroy_user_session_url
  end
  
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
    visit root_url
    current_url.should == cas_login_url
    fill_in "Username", :with => username
    fill_in "Password", :with => password
    click_on "Login"
  end
  
  describe "GET /protected/resource" do
    before { get '/' }

    it 'should redirect to sign-in' do
      response.should be_redirect
      response.should redirect_to(new_user_session_url)
    end
  end
  
  describe "GET /users/sign_in" do
    before { get new_user_session_url }
    
    it 'should redirect to CAS server' do
      response.should be_redirect
      response.should redirect_to(cas_login_url)
    end
  end
  
  it "should sign in with valid user" do
    sign_into_cas "joeuser", "joepassword"
    current_url.should == root_url
  end
  
  it "should fail to sign in with an invalid user" do
    sign_into_cas "invaliduser", "invalidpassword"
    current_url.should_not == root_url
  end

  describe "with a deactivated user" do
    before do 
      @user = User.first
      @user.deactivated = true
      @user.save!
    end

    it "should fail to sign in" do
      sign_into_cas "joeuser", "joepassword"
      current_url.should == new_user_session_url
    end
  end
  
  it "should register new CAS users if set up to do so" do
    User.count.should == 1
    TestAdapter.register_valid_user("newuser", "newpassword")
    Devise.cas_create_user = true
    sign_into_cas "newuser", "newpassword"
    
    current_url.should == root_url
    User.count.should == 2
    User.find_by_username("newuser").should_not be_nil
  end

  it "should register new CAS users if we're overriding the cas_create_user? method" do
    begin
      class << User
        def cas_create_user?
          true
        end
      end

      User.count.should == 1
      TestAdapter.register_valid_user("newuser", "newpassword")
      Devise.cas_create_user = false
      sign_into_cas "newuser", "newpassword"
      
      current_url.should == root_url
      User.count.should == 2
      User.find_by_username("newuser").should_not be_nil
    ensure
      class << User
        remove_method :cas_create_user?
      end
    end
  end
  
  it "should fail CAS login if user is unregistered and cas_create_user is false" do
    User.count.should == 1
    TestAdapter.register_valid_user("newuser", "newpassword")
    Devise.cas_create_user = false
    sign_into_cas "newuser", "newpassword"
    
    current_url.should_not == root_url
    User.count.should == 1
    User.find_by_username("newuser").should be_nil

    click_on "sign in using a different account"
    click_on "here"
    current_url.should == cas_login_url
    fill_in "Username", :with => "joeuser"
    fill_in "Password", :with => "joepassword"
    click_on "Login"
    current_url.should == root_url
  end
end
