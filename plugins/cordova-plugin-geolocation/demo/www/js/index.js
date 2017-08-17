/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
         var close = document.getElementsByClassName("closebtn");
         var i;

         for (i = 0; i < close.length; i++) {
            close[i].onclick = function(){
                var div = this.parentElement;
                div.style.opacity = "0";
                setTimeout(function(){ div.style.display = "none"; }, 600);
            }
         }
    },
    showElement:function(element){
      element.style.opacity = "1";
      element.style.display = "block";
    },
    hideElement:function(element){
      element.style.opacity = "0";
      element.style.display = "none";
    },
    receiveMessage: function(e) {
            console.log(e.origin);
            var data = JSON.parse(e.data);
            var action = data.action;
            console.log(e.data);
            document.getElementById("postMessageResult").innerHTML = e.data;
    },


    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    onDeviceReady: function() {
        app.receivedEvent('deviceready');
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        app.linkData();
    },
    successMessage:'',
    errorAlert:'',
    errorMessage: '',
    location:'',
    linkData: function() {
        document.getElementById("promptLocationService").addEventListener("click", this.promptLocationService, false);
        document.getElementById("getLocation").addEventListener("click", this.getLocation, false);
        document.getElementById("getAddressFromLocation").addEventListener("click", this.getAddressFromLocation, false);

        document.getElementById("getLocationFromAddress").addEventListener("click", this.getLocationFromAddress, false);

        document.getElementById("startWatchLocation").addEventListener("click", this.startWatchLocation, false);
        document.getElementById("startIntervalWatchLocation").addEventListener("click", this.startIntervalWatchLocation, false);

        document.getElementById("stopWatchLocation").addEventListener("click", this.stopWatchLocation, false);

        app.successMessage =  document.getElementById("successMessage");
        app.errorAlert =  document.getElementById("errorAlert");
        app.errorMessage =  document.getElementById("errorMessage");

        window.addEventListener('message', app.receiveMessage,false);
    },
    promptLocationService: function(){
        cordovaCells.Geolocation.promptForLocationService(app.success, app.error);
    },
    getLocation: function() {
        cordovaCells.Geolocation.getCurrentPosition(function(result){
          app.success(result);
          app.location = result;
        },
        app.error);
    },
    getAddressFromLocation: function(){
         console.log("Location: " + JSON.stringify(app.location));
        cordovaCells.Geolocation.getAddressFromLocation(app.location, app.success, app.error);
    },
    getLocationFromAddress: function(){
        var address = document.getElementById("address").value;
        var options = {
            addressLine: address
        };
        cordovaCells.Geolocation.getLocationFromAddress(options, app.success, app.error);
    },
    startWatchLocation: function() {
        cordovaCells.Geolocation.watchLocation(null, app.success, app.error);
    },
    startIntervalWatchLocation: function() {
        var interval = {"interval" : 30000}
        cordovaCells.Geolocation.watchLocation(interval, app.success, app.error);
    },
    stopWatchLocation: function(){
        cordovaCells.Geolocation.clearWatchLocation(app.success, app.error);
    },
    success: function(data) {
        console.log(JSON.stringify(data));
        app.showElement(app.successMessage);
        app.hideElement(app.errorAlert);
        app.successMessage.innerHTML = 'Success: ' + JSON.stringify(data);
    },
    error: function(error) {
        console.log(error);
        app.showElement(app.errorAlert);
        app.hideElement(app.successMessage);
        app.errorMessage.innerHTML =  '<strong>Error!</strong> ' + error.message;
    }

};

app.initialize();