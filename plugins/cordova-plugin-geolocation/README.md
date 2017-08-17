<a href="url-repo"><img src="https://img.shields.io/badge/android-available-green.svg?style=flat"/></a>
<a href="url-repo"><img src="https://img.shields.io/badge/ios-available-green.svg?style=flat"/></a>
<a href="url-repo"><img src="https://img.shields.io/badge/windows-available-green.svg?style=flat"/></a>

# Cordova Geolocation Plugin

## Introduction

This plugin is for use with [Cordova](http://incubator.apache.org/cordova/) and allows your application get the location of the device (latitude, longitude, altitude, accuracy) and the literal of the address associated to the location.

## Dependencies

+ This plugin depends on [Plugin Native Core > 1.1.0](url-to-remote/cordova-cells-native-core.git)

## Installation

In order to get the plugin installed using Cordova CLI:

+ Navigate inside root folder in your Cordova project.
+ Open a shell pointing to that path and type the next Command.

**Parameters**

Name | Type | Description
--------- | ------------ | ------------
`GPS_REQUIRED` | `boolean` | Boolean value that indicates whether the application requires gps [default = false] **(Not necessary in iOS)**

+ When you declare GPS_REQUIRED=true, you are specifying that the application cannot function, or is not designed to function, when gps is not present on the device.

+ When you declare GPS_REQUIRED=false, it means that the application prefers to use the feature if present on the device, but that it is designed to function without gps, if necessary.


~~~sh
cordova plugin add url-to-remote/cordova-plugin-geolocation.git#TAGNumber
~~~

For additional info, take a look at the [Cordova Plugin Specification](https://github.com/alunny/cordova-plugin-spec).

## Plugin API

* ### PromptForLocationService

  Prompts the user to activate the location service

**Call**

~~~js
window.cordovaCells.Geolocation.promptForLocationService();
~~~


* ### GetCurrentPosition

This method will response with an object that contains the location of the device.

**Call**

~~~js
window.cordovaCells.Geolocation.getCurrentPosition();
~~~

**Success Response**

~~~js
{accuracy: 5, latitude: 21.2827778, longitude: -157.8294444, altitude: 0}
~~~

**Error Response**

~~~js
{"code":2, "message":"Permision denied"}
{"code":3, "message":"Not available"}
{"code":442, "message":"The location service is unable to retrieve a location right away."}
{"code":446, "message":"Location service is disabled"}
~~~

* ### GetAddressFromLocation

This method will response with an object that contains the literal address associated to a given location.

**Parameters**

Name | Type | Description
--------- | ------------ | ------------
`location` | `JSON Object` |JSON Object data for plugin geolocation
`location.accuracy` | `int` | The accuracy level for the location search function
`location.latitude` | `double` | latitude of location
`location.longitude` | `double` | longitude of location
`location.altitude` | `int` | altitude of location

**Call**

~~~js
var location = {};
location.accuracy = -1;
location.latitude = 21.28;
location.longitude = -157.82;
location.altitude = 0;
window.cordovaCells.Geolocation.getAddressFromLocation(location);
~~~

**Success Response**

~~~js
{address: [{addressLine: "417 Launiu St Honolulu, HI  96815 United States ", longitude: -157.8294444, latitude: 21.2827778}]}
~~~

**Error Response**

~~~js
{"code":1, "message":"Malformed param"}
{"code":440, "message":"Geocode converter error"}
{"code":441, "message":"Latitude and longitude are empty."}
{"code":442, "message":"The location service is unable to retrieve a location right away."}
{"code":446, "message":"Location service is disabled"}
~~~

* ### GetLocationFromAddressCommand

This method will response with an object that contains the location associated to a given address.

**Parameters**

Name | Type | Description
--------- | ------------ | ------------
`address` | `JSON Object` |JSON Object data for plugin geolocation
`address.addressLine` | `string` | The address that is going to use to make location search

**Call**

~~~js
var address = {};
address.addressLine = "Gran Via, Madrid";
window.cordovaCells.Geolocation.getLocationFromAddress(address);
~~~

**Success Response**

~~~js
{"accuracy":-1, "latitude":21.28, "longitude": -157.82, "altitude": 0}
~~~

**Error Response**

~~~js
{"code":1, "message":"Malformed param"}
{"code":443, "message":"The location direct is unable to retrieve a location right away."}
{"code":446, "message":"Location service is disabled"}
~~~

* ### WatchLocation

This method will assign an observer to the location updates and with each one it will send a postmessage to the web side with an object that contains the literal address associated to the location update.

**Parameters**

Name | Type | Description
--------- | ------------ | ------------
`interval` | `JSON Object` |JSON Object data for plugin geolocation
`interval.interval` | `long` | The interval used for return a location. If you don't want to set interval you can send a JSON Object empty

**Call**

~~~js
var interval = {};
interval.interval = 30000;
window.cordovaCells.Geolocation.watchLocation(interval);
~~~

**Success Response**

~~~js
"OK"
{"pluginName":"GeolocationPlugin","payload":{"latitude":40.47989994863291,"longitude":-3.703401088714599,"accuracy":5,"altitude":0},"origin":"cellsNativePlugin","action":"location"}
.
..
...
{"pluginName":"GeolocationPlugin","payload":{"latitude":40.47980201998346,"longitude":-3.701287508010864,"accuracy":5,"altitude":0},"origin":"cellsNativePlugin","action":"location"}
.
..
...
~~~

**Error Response**

~~~js
{"code":2, "message":"Permision denied"}
{"code":3, "message":"Not available"}
{"code":442, "message":"The location service is unable to retrieve a location right away."}
{"code":446, "message":"Location service is disabled"}
~~~

* ### ClearWatchLocation

This method will disabled the previous observer to the location updates.

**Call**

~~~js
window.cordovaCells.Geolocation.clearWatchLocation();
~~~

**Success Response**

~~~js
"OK"
~~~
**Error Responses**

> At the moment, there is no defined error for this method.

## Platform details

This plugin is available for android,ios and windows
