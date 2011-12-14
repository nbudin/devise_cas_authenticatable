require 'spec_helper'

describe "routing" do
  include RSpec::Rails::RoutingExampleGroup

  it "routes to #service" do 
    get("/users/service").should route_to("devise/cas_sessions#service")
  end
  
  it "routes to #new" do
    get("/users/sign_in").should route_to("devise/cas_sessions#new")
  end
  
  it "routes to #create" do
    post("/users/sign_in").should route_to("devise/cas_sessions#create")
  end
  
  it "routes to #destroy" do
    get("/users/sign_out").should route_to("devise/cas_sessions#destroy")
  end
  
  it "routes to #unregistered" do
    get("/users/unregistered").should route_to("devise/cas_sessions#unregistered")
  end
end
  
describe Devise::CasSessionsController do
  include RSpec::Rails::ControllerExampleGroup  
  
  it "should have the right route names" do
    controller.should respond_to("user_service_path", "new_user_session_path", "user_session_path", "destroy_user_session_path")
    controller.user_service_path.should == "/users/service"
    controller.new_user_session_path.should == "/users/sign_in"
    controller.user_session_path.should == "/users/sign_in"
    controller.destroy_user_session_path.should == "/users/sign_out"
    controller.unregistered_user_session_path.should == "/users/unregistered"
  end
end