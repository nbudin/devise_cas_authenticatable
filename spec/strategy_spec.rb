require 'spec_helper'

describe Devise::Strategies::CasAuthenticatable, :type => 'acceptance' do
  include RSpec::Rails::RequestExampleGroup
  include Capybara::DSL

  before do
    RackCAS.config.server_url = 'http://www.example.com/'
    RackCAS.config.service = '/users/service'

    User.delete_all
    User.create! do |u|
      u.username = 'joeuser'
    end
  end

  after do
    page.driver.submit :delete, destroy_user_session_url, {}
  end

  def cas_logout_url
    @cas_logout_url ||= Devise.cas_base_url + '/logout?service'
  end

  def sign_into_cas(username, password)
    visit '/users/sign_in'
    fill_in 'username', with: username
    fill_in 'password', with: password
    click_button 'Login'
  end

  describe 'GET /protected/resource' do
    before { get '/' }

    it 'should redirect to sign-in' do
      expect(response).to be_redirect
      expect(response).to redirect_to(new_user_session_url, allow_other_host: true)
    end
  end

  it 'should sign in with valid user' do
    sign_into_cas 'joeuser', 'joepassword'
    expect(current_url).to eq(root_url)
  end

  it 'should register new CAS users if set up to do so' do
    expect(User.count).to eq(1)
    Devise.cas_create_user = true
    sign_into_cas 'newuser', 'newpassword'

    expect(current_url).to eq(root_url)
    expect(User.count).to eq(2)
    expect(User.find_by_username('newuser')).not_to be_nil
  end

  it "should register new CAS users if we're overriding the cas_create_user? method" do
    begin
      class << User
        def cas_create_user?
          true
        end
      end

      expect(User.count).to eq(1)
      Devise.cas_create_user = false
      sign_into_cas 'newuser', 'newpassword'

      expect(current_url).to eq(root_url)
      expect(User.count).to eq(2)
      expect(User.find_by(username: 'newuser')).not_to be_nil
    ensure
      class << User
        remove_method :cas_create_user?
      end
    end
  end

  it 'should fail CAS login if user is unregistered and cas_create_user is false' do
    expect(User.count).to eq(1)
    Devise.cas_create_user = false
    sign_into_cas 'newuser', 'newpassword'

    expect(current_url).not_to eq(root_url)
    expect(User.count).to eq(1)
    expect(User.find_by(username: 'newuser')).to be_nil

    click_on 'sign in using a different account'
    fill_in 'Username', with: 'joeuser'
    fill_in 'Password', with: 'joepassword'
    click_on 'Login'
    expect(current_url).to eq(root_url)
  end

  it 'should work correctly with Devise trackable' do
    user = User.first
    user.update!(last_sign_in_at: 1.day.ago, last_sign_in_ip: '1.2.3.4', sign_in_count: 41)
    sign_into_cas 'joeuser', 'joepassword'

    user.reload
    expect(user.last_sign_in_at).to be >= 1.hour.ago
    expect(user.sign_in_count).to eq(42)
  end
end
