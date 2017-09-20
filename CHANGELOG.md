# Changelog for devise\_cas\_authenticatable

## Version 1.10.3 - July 28, 2017

* Rails 5.1 deprecation fix (thanks @jamgregory!)

## Version 1.10.2 - July 28, 2017

* Correct an issue where the single sign-out logs would incorrectly state the session was found (thanks @hugohernani!)
* Document how to change the SSO strategy (thanks again @hugohernani!)

## Version 1.10.1 - July 17, 2017

* Yet another Rails 5 compatibility fix with single sign-out (CacheStore's API for destroying sessions changed)

## Version 1.10.0 - February 6, 2017

* Support Redis as a single sign-out store (thanks @tubsandcans!)
* More Rails 5 compatibility fixes (thanks @debborafernandess and @drobny!)

## Version 1.9.2 - July 6, 2016

* Fix middleware syntax for Rails 5 compatibility (thanks @drobny!)

## Version 1.9.1 - May 11, 2016

* Remove Gemfile symlink from built gem; hopefully this will make installation easier on Windows

## Version 1.9.0 - May 10, 2016

* No longer requires net/telnet in order to work properly, so Ruby 2.3 can work out-of-the-box

## Version 1.8.0 - May 4, 2016

* May the 4th be with you!
* Prevent redirect loops when using memcached as a session store (thanks @fabioperrella!)

## Version 1.7.1 - February 2, 2016

* Work around weird `#try` behavior on older Rails versions

## Version 1.7.0 - December 18, 2015

* Support RedisSessionStore (thanks @dandyn!)
* Suppress warnings about `Devise.secret_key` not being set in production mode (thanks @joraff!)

## Version 1.6.1 - December 18, 2015

* Allow single sign-out code to find the app's session store when NewRelic is in the middleware stack (thanks @brendancarney!)

## Version 1.6.0 - October 21, 2015

* Add support for the Dalli session store (thanks @bonyiii!)

## Version 1.5.0 - July 27, 2015

* Generation of cas_action_url is now done by a customizable class, so you can use Rails routes to provide this (thanks to @eturino again!)

## Version 1.4.1 - July 23, 2015

* Internal refactor to avoid conflicting with common route names, specifically logout_url (thanks to @eturino!)

## Version 1.4.0 - May 8, 2015

* Allow changing the CAS response field used as the unique key for finding users (thanks once again to @gmoore!)

## Version 1.3.8 - April 24, 2015

* Remove a deprecated dependency (thanks to @gmoore)
* Fix a wrong variable name that could break debug logging (thanks again to @gmoore)

## Version 1.3.7 - July 17, 2014

* Be less verbose in the log during single sign-out (thanks to @liudangyi)

## Version 1.0.1 - July 6, 2014

* Backport the 1.1.x series' logout_url features to the 1.0.x series for super-old apps

## Version 1.3.6 - February 5, 2014

* Better single sign-out support for ActiveRecord session store users and README fixes (thanks to @fernandomantoan)

## Version 1.3.5 - January 30, 2014

* Don't redirect to the (probably useless) Devise login page when the user is unauthorized - this is the CAS server's responsibility. (thanks to @kylejginavan)

## Version 1.3.4 - January 10, 2014

* Redirect to CAS logout URL when Warden receives the :inactive status, which should allow using active_for_authentication? (thanks to @bentoncreation)

## Version 1.3.3 - December 13, 2013

* Bug fix for single sign out when using Rack >= 1.5 (thanks to @activars)

## Version 1.3.2 - August 16, 2013

* Rails 4 deprecation warning fix (thanks to @reidmix)

## Version 1.3.1 - July 29, 2013

* Rails 4 compatibility fix (thanks to @McRipper)

## Version 1.3.0 - May 12, 2013

* Drop support for Rails 2.3, Devise 1.0 and 1.1
* Custom failure class for optional redirecting to logout url upon timeout (thanks to @geoffroh and @kylejginavan)

## Version 1.2.1 - April 16, 2013

* Bug fix: use Devise.sign_out_via to configure the HTTP verb sign_out will accept.

## Version 1.2.0 - March 6, 2013

* Rewrite of the single sign-out module to improve compatibility with newer Devise versions, other ORMs, and be less complex overall (thanks [Jeremy Haile](https://github.com/jeremyhaile) and [Endel Dreyer](https://github.com/endel)!)

## Version 1.1.4 - January 23, 2013

* Bug fix: don't modify request.protocol when generating a logout_url (thanks [Tse-Ching Ho](https://github.com/tsechingho)!)

## Version 1.1.3 - January 15, 2013

* Rails 4 compatibility fixes (thanks [Aaron Patterson](https://github.com/tenderlove)!)
* Support the service_url parameter in rubycas-client on logout (thanks [Kyle Ginavan](https://github.com/kylejginavan)!)

## Version 1.1.2 - May 23, 2012

* Only do schema stuff if using Devise 2.0.x or below

## Version 1.1.1 - April 2, 2012

* Add cas_client_config_options so that users can add unsupported RubyCAS options such as encode_extra_attributes_as

## Version 1.1.0 - March 5, 2012

* Add configurable destination and follow URL support (thanks [Dyson Simmons](https://github.com/dyson)!)
* Allow applications deployed at sub-URIs to work (thanks [Tod Detre](https://github.com/tod)!)
* Only add trailing slash to base URI if it's not already present (thanks [joe81](https://github.com/joe81)!)
* Some documentation updates.
