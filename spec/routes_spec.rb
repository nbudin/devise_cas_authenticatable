require 'spec_helper'

describe 'routing' do
  include RSpec::Rails::RoutingExampleGroup

  it 'routes to #service' do
    expect(get('/users/service')).to route_to('devise/cas_sessions#service')
  end

  it 'routes to #new' do
    expect(get('/users/sign_in')).to route_to('devise/cas_sessions#new')
  end

  it 'routes to #create' do
    expect(post('/users/sign_in')).to route_to('devise/cas_sessions#create')
  end

  it 'routes to #destroy' do
    expect(delete('/users/sign_out')).to route_to('devise/cas_sessions#destroy')
  end

  it 'routes to #unregistered' do
    expect(get('/users/unregistered')).to route_to('devise/cas_sessions#unregistered')
  end
end

describe Devise::CasSessionsController do
  include RSpec::Rails::ControllerExampleGroup

  it 'should have the right route names' do
    expect(controller).to respond_to('user_service_path', 'new_user_session_path', 'user_session_path', 'destroy_user_session_path')
    expect(controller.user_service_path).to eq('/users/service')
    expect(controller.new_user_session_path).to eq('/users/sign_in')
    expect(controller.user_session_path).to eq('/users/sign_in')
    expect(controller.destroy_user_session_path).to eq('/users/sign_out')
    expect(controller.unregistered_user_session_path).to eq('/users/unregistered')
  end
end
