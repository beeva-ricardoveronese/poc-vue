/*global cordova, module*/

module.exports = {

	getCurrentPosition: function (successCallback, errorCallback)  {
		 cordova.exec(successCallback, errorCallback, "Geolocation","getCurrentPosition", []);
	},

	getAddressFromLocation: function (location, successCallback, errorCallback)  {
		 cordova.exec(successCallback, errorCallback, "Geolocation","getAddressFromLocation", [location]);
	},

	getLocationFromAddress: function (address, successCallback, errorCallback)  {
		 cordova.exec(successCallback, errorCallback, "Geolocation","getLocationFromAddress", [address]);
	},

	watchLocation: function (interval, successCallback, errorCallback)  {
		 cordova.exec(successCallback, errorCallback, "Geolocation","watchLocation", [interval]);
	},

	clearWatchLocation: function (successCallback, errorCallback)  {
		 cordova.exec(successCallback, errorCallback, "Geolocation","clearWatchLocation", []);
	},

	promptForLocationService: function (successCallback, errorCallback)  {
  		 cordova.exec(successCallback, errorCallback, "Geolocation","promptForLocationService", []);
  	},

};
