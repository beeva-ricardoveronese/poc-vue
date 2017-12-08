# BEEVA PoC: Healthy Cart with Vue.js

![logo](https://vuejs.org/images/logo.png)


## Beeva-poc-vue-usecases
PoC using Vue, PhoneGap, Firebase, Webpack and Framework7

Add food to cart: Implement a webapp/mobileapp in phonegap that gives the user the possibility to drag new elements to
the cart and calculate how much food properties the user will benefit and also points the bad qualities of the previous,
all that will get reflected on the top bar of the UI.

## Firebase Config
+ Create an empty Firebase project.
+ Open Realtime Database and import the file [firebaseData.json](init_config/firebaseData.json).
+ In rules tab, allow .read and .write without authentication.
+ Go to Project Overview -> Configuration.
+ Click in Add Firebase for the Web App. Copy the values in ***config/firebase.js*** using the file [firebase.js](init_config/firebase.js).


## Usage

    npm install
    npm run dev // local development
    npm run phonegap-run // for when you need to test the builds inside a browser
    npm run phonegap-ios // for ios builds
    npm run phonegap-android // for android builds
