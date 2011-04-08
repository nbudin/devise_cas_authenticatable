devise_cas_authenticatable
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

- Rails 2.3 or 3.0
- Devise 1.0 (for Rails 2.3) or 1.1 (for Rails 3.0)
- rubycas-client

Installation
------------

    gem install --pre devise_cas_authenticatable
    
and in your config/environment.rb (on Rails 2.3):

    config.gem 'devise', :version => '~> 1.0.6'
    config.gem 'devise_cas_authenticatable'

or Gemfile (Rails 3.0):

    gem 'devise', '~> 1.1.1'
    gem 'devise_cas_authenticatable'

Example
-------

I've modified the devise_example application to work with this gem.  You can find the results
[here](http://github.com/nbudin/devise_cas_example).
    
Setup
-----

Once devise\_cas\_authenticatable is installed, add the following to your user model:

    devise :cas_authenticatable
    
You can also add other modules such as token_authenticatable, trackable, etc.  Please do not
add database_authenticatable as this module is intended to replace it.

You'll also need to set up the database schema for this:

    create_table :users do |t|
      t.cas_authenticatable
    end

and, optionally, indexes:

    add_index :users, :username, :unique => true

Finally, you'll need to add some configuration to your config/initializers/devise.rb in order
to tell your app how to talk to your CAS server:

    Devise.setup do |config|
      ...
      config.cas_base_url = "https://cas.myorganization.com"
      
      # you can override these if you need to, but cas_base_url is usually enough
      # config.cas_login_url = "https://cas.myorganization.com/login"
      # config.cas_logout_url = "https://cas.myorganization.com/logout"
      # config.cas_validate_url = "https://cas.myorganization.com/serviceValidate"
      
      # By default, devise_cas_authenticatable will create users.  If you would rather
      # require user records to already exist locally before they can authenticate via
      # CAS, uncomment the following line.
      # config.cas_create_user = false  
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

* Implement CAS single sign-off support (maybe via a Rack middleware?)
* Write test suite
* Test on non-ActiveRecord ORMs
