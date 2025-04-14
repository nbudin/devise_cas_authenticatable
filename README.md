devise_cas_authenticatable [![Ruby](https://github.com/nbudin/devise_cas_authenticatable/actions/workflows/ruby.yml/badge.svg)](https://github.com/nbudin/devise_cas_authenticatable/actions/workflows/ruby.yml) [![Gem Version](https://badge.fury.io/rb/devise_cas_authenticatable.svg)](https://badge.fury.io/rb/devise_cas_authenticatable)
==========================

Written by Nat Budin<br/>
Taking a lot of inspiration from [devise_ldap_authenticatable](http://github.com/cschiewek/devise_ldap_authenticatable)

devise_cas_authenticatable is [CAS](http://www.jasig.org/cas) single sign-on support for
[Devise](http://github.com/plataformatec/devise) applications.  It acts as a replacement for
database_authenticatable.  It builds on [rack-cas](https://github.com/biola/rack-cas)
and should support just about any conformant CAS server (although I have personally tested it
using [rubycas-server](http://github.com/gunark/rubycas-server)).

Requirements
------------

- Rails 5.0 or greater
- Devise 4.0 or greater

devise_cas_authenticatable version 2 is a major rewrite
-------------------------------------------------------

devise_cas_authenticatable version 1 was based on
[rubycas-client](https://github.com/rubycas/rubycas-client).  Now that rubycas-client is deprecated,
devise_cas_authenticatable version 2 is based on [rack-cas](https://github.com/biola/rack-cas).

In order to upgrade, you'll need to:

* Make sure you're on a supported version of Devise (4.0 or above) and a supported version of Rails
  (5.0 or above)
* Add the rack-cas configuration to your application.rb (see below)
* Remove the cas_base_url, cas_login_url, cas_logout_url, cas_validate_url, and
  cas_client_config_options from your devise.rb initializer, if present
* If using single sign out: [set up rack-cas's built-in single sign out support](https://github.com/biola/rack-cas#single-logout)

Installation
------------

Add to your Gemfile:

    gem 'devise'
    gem 'devise_cas_authenticatable'

Setup
-----

Once devise\_cas\_authenticatable is installed, add the following to your user model:

```ruby
devise :cas_authenticatable
```

You can also add other modules such as token_authenticatable, trackable, etc.  Please do not
add database_authenticatable as this module is intended to replace it.

You'll also need to set up the database schema for this:

```ruby
create_table :users do |t|
  t.string :username, :null => false
end
```

We also recommend putting a unique index on the `username` column:

```ruby
add_index :users, :username, :unique => true
```

(Note: previously, devise\_cas\_authenticatable recommended using a `t.cas_authenticatable` method call to update the
schema.  Devise 2.0 has deprecated this type of schema building method, so we now recommend just adding the `username`
string column as above.  As of this writing, `t.cas_authenticatable` still works, but throws a deprecation warning in
Devise 2.0.)

You'll need to configure rack-cas so that it knows where your CAS server is.  See the
[rack-cas README](https://github.com/biola/rack-cas) for full instructions, but here is the
bare minimum:

```ruby
config.rack_cas.server_url = "https://cas.myorganization.com" # replace with your server URL
config.rack_cas.service = "/users/service" # If your user model isn't called User, change this
```

Rack-cas comes with a fake CAS server that it enables by default in the Rails test environment. This will log in any
username and password combination you use, and more information can be found in the
[rack-cas README](https://github.com/biola/rack-cas). If you want to enable Fake CAS in development as well, add this
to your Rails development config:

```ruby
config.rack_cas.fake = true
```

Finally, you may need to add some configuration to your config/initializers/devise.rb in order
to tell your app how to talk to your CAS server.  This isn't always required.  Here's an example:

```ruby
Devise.setup do |config|
  ...
  # The CAS specification allows for the passing of a follow URL to be displayed when
  # a user logs out on the CAS server. RubyCAS-Server also supports redirecting to a
  # URL via the destination param. Set either of these urls and specify either nil,
  # 'destination' or 'follow' as the logout_url_param. If the urls are blank but
  # logout_url_param is set, a default will be detected for the service.
  # config.cas_destination_url = 'https://cas.myorganization.com'
  # config.cas_follow_url = 'https://cas.myorganization.com'
  # config.cas_logout_url_param = nil

  # You can specify the name of the destination argument with the following option.
  # e.g. the following option will change it from 'destination' to 'url'
  # config.cas_destination_logout_param_name = 'url'

  # By default, devise_cas_authenticatable will create users.  If you would rather
  # require user records to already exist locally before they can authenticate via
  # CAS, uncomment the following line.
  # config.cas_create_user = false

  # If you don't want to use the username returned from your CAS server as the unique
  # identifier, but some other field passed in cas_extra_attributes, you can specify
  # the field name here.
  # config.cas_user_identifier = nil
end
```

Extra attributes
----------------

If your CAS server passes along extra attributes you'd like to save in your user records,
using the CAS extra_attributes parameter, you can define a method in your user model called
cas_extra_attributes= to accept these.  For example:

```ruby
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
```

Using without a database
------------------------

You don't have to save your user model to the database - you can simply store it in the session as is.
You can follow the following approach (inspired by [this article](https://4trabes.com/2012/10/31/remote-authentication-with-devise/)):

```ruby
require 'active_model'

class User
  attr_accessor :id, :extra_attributes

  include ActiveModel::Validations
  extend ActiveModel::Callbacks
  extend Devise::Models
  define_model_callbacks :validation

  class << self
    # override these methods to work nicely with Devise
    def serialize_from_session(id, _)
      return nil if id.nil?
      self.new(id: id)
    end

    def serialize_into_session(record)
      [record.id, '']
    end

    def logger
      ActiveRecord::Base.logger # e.g. assuming you are using Rails
    end

    # Overload of default callback to ensure we don't try to create any database records.
    def authenticate_with_cas_details(cas_details)
      self.new(cas_details['extra_attributes'])
    end
  end
  
  def initialize(extra_attributes: nil, id: nil)
    self.extra_attributes = extra_attributes
    self.id = id
  end

  devise :cas_authenticatable
end
```

See also
--------

* [CAS](http://www.jasig.org/cas)
* [rack-cas](https://github.com/biola/rack-cas)
* [Devise](http://github.com/plataformatec/devise)
* [Warden](http://github.com/hassox/warden)

License
-------

`devise_cas_authenticatable` is released under the terms and conditions of the MIT license.  See the LICENSE file for more
information.
