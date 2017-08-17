var cordova = require('cordova');

module.exports = {
  promptForLocationService: function (successCallback, errorCallback) {
		var res;
		var p = new Promise(function (resolve, reject) {
			res = GeolocationRuntimeComponent.GeolocationRuntimeComponent.promptForLocationServiceAsync();

			if (res != undefined) {
				resolve(res);
			} else {
				reject();
			}
		})
    .then(function (res) {
      var result = JSON.parse(res);

      if (result.error)
        errorCallback(result.error);
      else
        successCallback(result.data);
    })
    .catch(function () {
      errorCallback();
    });
	},

  getCurrentPosition: function (successCallback, errorCallback) {
		var res;
		var p = new Promise(function (resolve, reject) {
			res = GeolocationRuntimeComponent.GeolocationRuntimeComponent.getPositionAsync();

			if (res != undefined) {
				resolve(res);
			} else {
				reject();
			}
		})
    .then(function (res) {
      var result = JSON.parse(res);

      if (result.error)
        errorCallback(result.error);
      else
        successCallback(result.data);
    })
    .catch(function () {
      errorCallback();
    });
	},

	getAddressFromLocation: function (successCallback, errorCallback, location) {
    var res

    var p = new Promise(function (resolve, reject) {
      res = GeolocationRuntimeComponent.GeolocationRuntimeComponent.getAddressAsync(JSON.stringify(location[0]));

      if (res != undefined) {
        resolve(res);
      } else {
        reject();
      }
    })
    .then(function (res) {
      var result = JSON.parse(res);

      if (result.error)
        errorCallback(result.error);
      else
        successCallback(result.data);
    })
    .catch(function () {
      errorCallback();
    });
	},

  getLocationFromAddress: function (successCallback, errorCallback, address) {
    var res;

    var p = new Promise(function (resolve, reject) {
      res = GeolocationRuntimeComponent.GeolocationRuntimeComponent.getLocationFromAddressAsync(JSON.stringify(address[0]));

      if (res != undefined) {
        resolve(res);
      } else {
        reject();
      }
    })
    .then(function (res) {
      var result = JSON.parse(res);

      if (result.error)
        errorCallback(result.error);
      else
        successCallback(result.data);

    })
    .catch(function () {
      errorCallback();
    });

	},

	watchLocation: function (successCallback, errorCallback, interval) {
    var res;
    var p = new Promise(function (resolve, reject) {

      GeolocationRuntimeComponent.GeolocationRuntimeComponent.onpositionchangedevent = function (loc) {
        var location = JSON.parse(loc);

        if (location.data)
            window.postMessage(JSON.stringify(location.data), "*");
      };

      res = GeolocationRuntimeComponent.GeolocationRuntimeComponent.watchLocationAsync(JSON.stringify(interval[0]));

      if (res != undefined) {
        resolve(res);
      } else {
        reject();
      }
    })
    .then(function (res) {
      var result = JSON.parse(res);
      if (result.error)
        errorCallback(result.error);
      else
        successCallback(result.data);
    })
    .catch(function () {
      errorCallback();
    });
	},

	clearWatchLocation: function (successCallback, errorCallback) {
    res = GeolocationRuntimeComponent.GeolocationRuntimeComponent.clearWatchLocation();

    if (res) {
      GeolocationRuntimeComponent.GeolocationRuntimeComponent.onpositionchangedevent = null;

      var result = JSON.parse(res);

      if (result.error)
        errorCallback(result.error);
      else
        successCallback(result.data);
    }
    else {
      errorCallback();
    }
   }
};

require("cordova/exec/proxy").add("Geolocation", module.exports);
