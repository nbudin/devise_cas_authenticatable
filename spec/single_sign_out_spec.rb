require 'spec_helper'

describe DeviseCasAuthenticatable::SingleSignOut::WardenFailureApp do
  include RSpec::Rails::RequestExampleGroup
  include Capybara::DSL

  describe "A logged in user with a timed out session" do

    before do      
      Devise.cas_base_url = "http://www.example.com/cas_server"
      User.delete_all
      @user = User.create!(:username => "joeuser")
    end

    describe "using the default warden failure app" do

      before do
        sign_into_cas "joeuser", "joepassword"
      end

      it "redirects to cas_login_url when warden is thrown" do
        Devise::FailureApp.any_instance.expects(:redirect_url).returns(cas_login_url)
        Timecop.travel(Devise.timeout_in) do
          visit root_url
        end
        current_url.should == root_url
      end

    end

    describe "using the custom WardenFailureApp" do

      before do

        Devise.warden_config[:failure_app] = DeviseCasAuthenticatable::SingleSignOut::WardenFailureApp
        sign_into_cas "joeuser", "joepassword"
      end

      it "uses the redirect_url from the custom failure class" do
        DeviseCasAuthenticatable::SingleSignOut::WardenFailureApp.any_instance.expects(:redirect_url).returns(destroy_user_session_url)
        Timecop.travel(Devise.timeout_in) do
          visit root_url
        end
        current_url.should match(/#{cas_logout_url}/)
      end

    end

  end

end
