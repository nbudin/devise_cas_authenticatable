require 'spec_helper'

describe Devise::Models::CasAuthenticatable do  

  describe "When the user lookup is by something other than username" do
    before(:each) do
      @ticket = CASClient::ServiceTicket.new("ST-test", nil)
      @ticket.extra_attributes = {:id => 10}
      @ticket.success = true
      @ticket.user = "testusername"

      Devise.cas_create_user = false

      #
      # We needed to stub :find_for_authentication to return false
      # but wanted to allow other respond_to? calls to function
      # normally 
      #
      User.stubs(:respond_to?) do |arg|
        if arg == :find_for_authentication
          return false
        else
          return User.respond_to? arg
        end
      end
    end

    it "should authenticate using whatever is specified in config.cas_user_identifier" do
      Devise.cas_user_identifier = :id
      Devise.cas_username_column = :id

      User.expects(:find).with(:first, {:conditions => {:id => 10}})

      User.authenticate_with_cas_ticket(@ticket)

      #Reset this otherwise it'll blow up other specs
      Devise.cas_user_identifier = nil
    end

    it "should authenticate as normal is config.cas_user_identifier is not set" do
      Devise.cas_user_identifier = nil
      Devise.cas_username_column = :username
      User.expects(:find).with(:first, {:conditions => {:username => @ticket.user}})
      User.authenticate_with_cas_ticket(@ticket)
    end

    it "should return nil if cas_user_identifier is not in cas_extra_attributes" do
      Devise.cas_user_identifier = :unknown_ticket_field
      Devise.cas_username_column = :username   
      User.expects(:find).never
      User.authenticate_with_cas_ticket(@ticket).should be_nil 

      #Reset this otherwise it'll blow up other specs
      Devise.cas_user_identifier = nil
    end
  end
end