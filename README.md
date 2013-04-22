devise_cas_authenticatable [![Build Status](https://secure.travis-ci.org/nbudin/devise_cas_authenticatable.png)](http://travis-ci.org/nbudin/devise_cas_authenticatable)
==========================

Written by Nat Budin<br/>
Taking a lot of inspiration from [devise_ldap_authenticatable](http://github.com/cschiewek/devise_ldap_authenticatable)

devise_cas_authenticatable is [CAS](http://www.jasig.org/cas) single sign-on support for
[Devise](http://github.com/plataformatec/devise) applications.  It acts as a replacement for
database_authenticatable.  It builds on [rubycas-client](http://github.com/gunark/rubycas-client)
and should support just about any conformant CAS server (although I have personally tested it
using [rubycas-server](http://github.com/gunark/rubycas-server)).

Requirements
------------

- Rails 2.3 or greater (works with 3.x versions as well)
- Devise 1.0 or greater
- rubycas-client

Installation
------------

    gem install --pre devise_cas_authenticatable
    
and in your config/environment.rb (on Rails 2.3):

    config.gem 'devise', :version => '~> 1.0.6'
    config.gem 'devise_cas_authenticatable'

or Gemfile (Rails 3.x):

    gem 'devise'
    gem 'devise_cas_authenticatable'

Setup
-----

Once devise\_cas\_authenticatable is installed, add the following to your user model:

    devise :cas_authenticatable
    
You can also add other modules such as token_authenticatable, trackable, etc.  Please do not
add database_authenticatable as this module is intended to replace it.

You'll also need to set up the database schema for this:

    create_table :users do |t|
      t.string :username, :null => false
    end

We also recommend putting a unique index on the `username` column:

    add_index :users, :username, :unique => true

(Note: previously, devise\_cas\_authenticatable recommended using a `t.cas_authenticatable` method call to update the
schema.  Devise 2.0 has deprecated this type of schema building method, so we now recommend just adding the `username`
string column as above.  As of this writing, `t.cas_authenticatable` still works, but throws a deprecation warning in
Devise 2.0.)

Finally, you'll need to add some configuration to your config/initializers/devise.rb in order
to tell your app how to talk to your CAS server:

    Devise.setup do |config|
      ...
      config.cas_base_url = "https://cas.myorganization.com"
      
      # you can override these if you need to, but cas_base_url is usually enough
      # config.cas_login_url = "https://cas.myorganization.com/login"
      # config.cas_logout_url = "https://cas.myorganization.com/logout"
      # config.cas_validate_url = "https://cas.myorganization.com/serviceValidate"
      
      # The CAS specification allows for the passing of a follow URL to be displayed when
      # a user logs out on the CAS server. RubyCAS-Server also supports redirecting to a
      # URL via the destination param. Set either of these urls and specify either nil,
      # 'destination' or 'follow' as the logout_url_param. If the urls are blank but
      # logout_url_param is set, a default will be detected for the service.
      # config.cas_destination_url = 'https://cas.myorganization.com'
      # config.cas_follow_url = 'https://cas.myorganization.com'
      # config.cas_logout_url_param = nil

      # By default, devise_cas_authenticatable will create users.  If you would rather
      # require user records to already exist locally before they can authenticate via
      # CAS, uncomment the following line.
      # config.cas_create_user = false

      # If you want to use the Devise Timeoutable module with single sign out, 
      # uncommenting this will redirect timeouts to the logout url, so that the CAS can
      # take care of signing out the other serviced applocations. Note that each
      # application manages timeouts independently, so one application timing out will 
      # kill the session on all applications serviced by the CAS.
      # config.warden do |manager|
      #   manager.failure_app = DeviseCasAuthenticatable::SingleSignOut::WardenFailureApp
      # end
    end

Extra attributes
----------------

If your CAS server passes along extra attributes you'd like to save in your user records,
using the CAS extra_attributes parameter, you can define a method in your user model called
cas_extra_attributes= to accept these.  For example:

    class User < ActiveRecord::Base
      devise :cas_authenticatable
      
      def cas_extra_attributes=(extra_attributes)
        extra_attributes.each do |name, value|
          case name.to_sym
          when :fullname
            self.fullname = value
          when :email
            self.email = value
          end
        end
      end
    end

See also
--------

* [CAS](http://www.jasig.org/cas)
* [rubycas-server](http://github.com/gunark/rubycas-server)
* [rubycas-client](http://github.com/gunark/rubycas-client)
* [Devise](http://github.com/plataformatec/devise)
* [Warden](http://github.com/hassox/warden)

TODO
----

* Test on non-ActiveRecord ORMs

License
-------

`devise_cas_authenticatable` is released under the terms and conditions of the MIT license.  See the LICENSE file for more
information.
