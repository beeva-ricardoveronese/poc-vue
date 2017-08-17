# DEMO for the Geolocation Plugin

> Read and follow this tutorial if you want to easily test the Geolocation Plugin for the Cordova platform.     

## Installation

This requires phonegap/cordova CLI 5.0+ ( current stable v1.4.2 )

```
sudo npm install -g cordova
```
then create a new project  

```
cordova create testGeolocation com.cells.test.geolocation TestGeolocation
```

Once finised the creation, enter on the app folder and add the Geolocation Plugin with:_

```
cd ..

cordova plugin add 'url-to-remote/cordova-plugin-geolocation.git'
```

Once installed the plugin you could copy the content of the www folder on this repo onto the app folder created before, and then run the app

```
cordova run android
```
OR

```
cordova run ios
```
OR

```
cordova run windows
```

And if you have the phone pluged on the laptop the app will start running on the device.

## Usage

Just run the demo and click on the "Location" button and you will see the response below the button.

After getting the location, you could get the address associated to this location given tapping on the "Get address from location" button and you will see the response below the button.

You could get an observer to Location updates by tapping "Start watch location" button. Then the responses of this action will be written below the button, till you stop the location updates by tapping "Stop watch location" button.

For check the last feature, we could emulate that the simulator or the device on our table is in a route by adding to the project a .gpx file. An example is given in  the folder called "demo/www"; file: route.gpx
