devise_bushido_authenticatable
=======

devise_bushido_authenticatable provides single sign-on support for Bushido applications, that use 
[Devise](http://github.com/plataformatec/devise) for authentication. It acts as a **replacement for the database_authenticatable option that devise provides**

For applications running on Bushido, the authentication server provides the following user data:

* ido_id - a string that is unique to the user
* email - user's email address
* first_name - user's first name
* last_name - user's last name
* locale - user's locale


Requirements
------------

- Rails 2.3 or 3.0
- Devise 1.0 or greater

Installation
------------

    gem install --pre devise_bushido_authenticatable
    
### Rails 3.x: Add the following to your Gemfile

    gem 'devise'
    gem 'devise_bushido_authenticatable'

This has been tested with 3.1 rc5 too. So feel safe to use it :)

### Rails 2.3: Add the following in your config/environment.rb
    
    config.gem 'devise', :version => '~> 1.0.6'
    config.gem 'devise_bushido_authenticatable'


Setup
-----

### 1.) Add the following to your devise model

    devise :bushido_authenticatable
    
You can add other modules like trackable, but **do not use database_authenticatable**. bushido_authenticatable is a replacement for that.

### 2.) Modify schema migration

Add the field required for the auth to work. For example, if the devise model is called User, add *bushido_authenticatable* to the schema like below.

    create_table :users do |t|
      t.bushido_authenticatable
    end

That will add a string field called *ido_id*, which is unique to each Bushido user.


### 3.) [OPTIONAL] Add ido_id to be indexed

    add_index :users, :ido_id, :unique => true

   
Extra attributes
----------------

When the user is authenticated, Bushido passed along the following extra attributes:

* email - user's email address
* first_name - user's first name
* last_name - user's last name
* locale - user's locale

If you find any of these attributes useful and want to capture them, add a bushido_extra_attributes method to your User model (or whichever is your devise model). Below is an example that saves the email and the locale of a user.

    class User < ActiveRecord::Base
      devise :bushido_authenticatable
      
      def bushido_extra_attributes(extra_attributes)
        extra_attributes.each do |name, value|
          case name.to_sym
          when :email
            self.email = value
          when :locale
            self.locale = value
          end
        end
      end
    end

The example above assumes that you have created fields called "email" and "locale" to save the attributes to. This gem doesn't create that for you. It has to be created manually and are optional.

__Note that these attributes might change anytime and are hence passed on as extra attributes. If defined, this method is called whenever the user logs into your app (starts a session). So when any of these are changed, your application will be able to capture those.__

**It is not advisable to use the user's email address to identify the user. Use the ido_id field for that purpose.**

Credits
--------
Based on [devise_cas_authenticatable](http://github.com/nbudin/devise_cas_authenticatable) by Nat Budin.

#### Tweaks by:

* Sean Grove
* Akash Manohar

[When contributing, add your name above and commit]

See also
--------

* [Devise](http://github.com/plataformatec/devise)
* [Warden](http://github.com/hassox/warden)


TODO
----

* Test on non-ActiveRecord ORMs
