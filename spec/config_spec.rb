require 'spec_helper'

module Devise
  def self.reset_cas_client!
    @@cas_client = nil
  end
end

describe Devise do
  before do
    Devise.cas_base_url = "http://www.example.com/cas_server"
  end
  
  after { Devise.reset_cas_client! }
  
  it "should figure out the base URL correctly" do
    Devise.cas_client.cas_base_url.should == "http://www.example.com/cas_server"
  end
  
  it 'should accept extra options for the CAS client object' do
    Devise.cas_client_config_options = { :encode_extra_attributes_as => :json }

    conf_options = Devise.cas_client.instance_variable_get(:@conf_options)
    conf_options.should_not be_nil
    conf_options[:encode_extra_attributes_as].should == :json
  end
end