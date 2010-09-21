require 'spec_helper'

describe Devise::CasSessionsController do
  include RSpec::Rails::ControllerExampleGroup
  
  it { should route(:get, "/users").to(:action => "service") }
  it { should route(:get, "/users/sign_in").to(:action => "create") }
  it { should route(:post, "/users/sign_in").to(:action => "create") }
  it { should route(:get, "/users/sign_out").to(:action => "destroy") }
  
  it "should have the right route names" do
    controller.should respond_to("new_user_session_path", "user_session_path", "destroy_user_session_path")
    controller.new_user_session_path.should == "/users/sign_in"
    controller.user_session_path.should == "/users/sign_in"
    controller.destroy_user_session_path.should == "/users/sign_out"
  end
end