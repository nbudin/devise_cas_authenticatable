require 'spec_helper'

describe DeviseCasAuthenticatable::SingleSignOut::WardenFailureApp do

  describe "#redirect_url" do

      before do
        Devise.cas_base_url = "http://www.example.com/cas_server"
        @failure_app = DeviseCasAuthenticatable::SingleSignOut::WardenFailureApp.new
        @failure_app.stubs(:flash).returns({})
      end

      describe "resulting from a timeout" do

        before do
          @failure_app.stubs(:warden_message).returns(:timeout)
        end

        it "returns the logout url" do
          @failure_app.send(:redirect_url).should match(/#{cas_logout_url}/)
        end

      end

      describe "resulting from a generic warden :throw error" do

        before do
          @failure_app.stubs(:warden_message).returns(nil)
          @failure_app.stubs(:flash).returns({})
        end

        it "calls the scope_path method to retrieve the standard redirect_url" do
          @failure_app.expects(:scope_path)
          @failure_app.send(:redirect_url)
        end

      end

  end

end