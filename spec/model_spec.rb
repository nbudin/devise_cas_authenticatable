# rubocop:disable Metrics/BlockLength

require 'spec_helper'

describe Devise::Models::CasAuthenticatable do

  describe 'When the user lookup is by something other than username' do
    before(:each) do
      Devise.cas_create_user = false
    end

    it 'should authenticate using whatever is specified in config.cas_user_identifier' do
      Devise.cas_user_identifier = :id
      Devise.cas_username_column = :id

      user = User.create!(username: 'testusername')
      User.authenticate_with_cas_details(cas_details_for_user(user))

      # Reset this otherwise it'll blow up other specs
      Devise.cas_user_identifier = nil
    end

    it 'should authenticate as normal is config.cas_user_identifier is not set' do
      Devise.cas_user_identifier = nil
      Devise.cas_username_column = :username

      user = User.create!(username: 'testusername')
      User.authenticate_with_cas_details(cas_details_for_user(user))
    end

    it 'should return nil if cas_user_identifier is not in cas_extra_attributes' do
      Devise.cas_user_identifier = :unknown_ticket_field
      Devise.cas_username_column = :username
      User.expects(:find).never
      expect(
        User.authenticate_with_cas_details(
          {
            'user' => 'testusername',
            'extra_attributes' => { id: 10 }
          }
        )
      ).to be_nil

      # Reset this otherwise it'll blow up other specs
      Devise.cas_user_identifier = nil
    end

    def cas_details_for_user(user)
      { 'user' => user.username, 'extra_attributes' => { id: user.id } }
    end
  end
end
