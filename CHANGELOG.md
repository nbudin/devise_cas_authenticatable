# Changelog for devise\_cas\_authenticatable

## Version 1.1.2 - May 23, 2012

* Only do schema stuff if using Devise 2.0.x or below

## Version 1.1.1 - April 2, 2012

* Add cas_client_config_options so that users can add unsupported RubyCAS options such as encode_extra_attributes_as

## Version 1.1.0 - March 5, 2012

* Add configurable destination and follow URL support (thanks [Dyson Simmons](https://github.com/dyson)!)
* Allow applications deployed at sub-URIs to work (thanks [Tod Detre](https://github.com/tod)!)
* Only add trailing slash to base URI if it's not already present (thanks [joe81](https://github.com/joe81)!)
* Some documentation updates.
