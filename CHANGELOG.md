# Changelog for devise\_cas\_authenticatable

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
