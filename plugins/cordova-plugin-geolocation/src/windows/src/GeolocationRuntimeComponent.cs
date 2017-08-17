
namespace GeolocationRuntimeComponent
{
    #region Namespaces
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Windows.Devices.Geolocation;
    using Windows.Foundation;
    using Windows.Services.Maps;
    using PluginBase.Classes;
    using PluginBase.Helpers;
    using Windows.System;
    #endregion

    /// <summary>
    /// Get the location of the device and the literal of the address associated to the location
    /// </summary>
    public sealed class GeolocationRuntimeComponent
    {
        #region Private variables
        private static Geolocator geolocator;
        private static string geolocationURL = "ms-settings:privacy-location";
        #endregion

        #region Private errors

        private static Error ErrorGeocodeConverter = new Error { Code = 440, Message = "Geocode converter error." };
        private static Error ErrorLatLongEmpty = new Error { Code = 441, Message = "Latitude and longitude are empty." };
        private static Error ErrorLocationUnknown = new Error { Code = 442, Message = "The location service is unable to retrieve a location right away." };
        private static Error ErrorDirectLocationUnknown = new Error { Code = 443, Message = "The location direct is unable to retrieve a location right away." };
        
        #endregion

        #region Private Methods
        
        private static async Task<string> PromptForLocationServiceInternalAsync()
        {
            bool opened = await Launcher.LaunchUriAsync(new Uri(geolocationURL));

            if (opened)
                return PluginBase.ResponseManager.CreateSuccessResponse(PluginBase.Constants.OK);
            else
                return PluginBase.ResponseManager.CreateErrorResponse(ErrorTypes.ErrorNotInstalled);
        }

        /// <summary>
        /// Gets position with accuracy, longitude, latitude and altitude.
        /// </summary>
        /// <returns>JSON string PositionResponse</returns>
        private static async Task<string> GetPositionInternalAsync()
        {
            string response = string.Empty;
            Geoposition pos = null;

            try
            {
                // Request permission to access location
                var accessStatus = await Geolocator.RequestAccessAsync();

                switch (accessStatus)
                {
                    case GeolocationAccessStatus.Allowed:
                        Geolocator geolocator = new Geolocator();
                        pos = await geolocator.GetGeopositionAsync();

                        Position newPosition = new Position()
                        {
                            Accuracy = (int)pos.Coordinate.Accuracy,
                            Latitude = pos.Coordinate.Point.Position.Latitude,
                            Longitude = pos.Coordinate.Point.Position.Longitude,
                            Altitude = (int)pos.Coordinate.Point.Position.Altitude
                        };

                        response = PluginBase.ResponseManager.CreateSuccessResponse(newPosition);
                        break;

                    case GeolocationAccessStatus.Denied:
                        response = PluginBase.ResponseManager.CreateErrorResponse(ErrorTypes.ErrorPermissionDenied);
                        break;

                    case GeolocationAccessStatus.Unspecified:
                        response = PluginBase.ResponseManager.CreateErrorResponse(ErrorLocationUnknown);
                        break;
                }
            }
            catch (Exception)
            {
                response = PluginBase.ResponseManager.CreateErrorResponse(ErrorTypes.ErrorNotAvailable);
            }

            return response;
        }

        /// <summary>
        /// Gets string address.
        /// </summary>
        /// <param name="location">position object</param>
        /// <returns>JSON string AddressResponse</returns>
        private static async Task<string> GetAddressInternalAsync(LocationParam location)
        {
            string response = string.Empty;

            BasicGeoposition position = new BasicGeoposition {
                Latitude = location.Latitude,
                Longitude = location.Longitude
            };

            Geopoint pointToReverseGeocode = new Geopoint(position);

            // Reverse geocode the specified geographic location.
            MapLocationFinderResult result = await MapLocationFinder.FindLocationsAtAsync(pointToReverseGeocode);

            switch (result.Status)
            {
                case MapLocationFinderStatus.BadLocation:
                    response = PluginBase.ResponseManager.CreateErrorResponse(ErrorGeocodeConverter);
                    break;

                case MapLocationFinderStatus.Success:

                    if (result.Locations != null && result.Locations.Count > 0)
                    {
                        string address = result.Locations[0].Address.FormattedAddress;

                        Address newAddress = new Address()
                        {
                            AddressLine = address,
                            Latitude = position.Latitude,
                            Longitude = position.Longitude
                        };

                        AddressList addressList = new AddressList() { Address = new List<Address>() };
                        addressList.Address.Add(newAddress);
                        response = PluginBase.ResponseManager.CreateSuccessResponse(addressList);
                    }
                    else
                    {
                        response = PluginBase.ResponseManager.CreateErrorResponse(ErrorLocationUnknown);
                    }
                           
                    break;

                default:
                    response = PluginBase.ResponseManager.CreateErrorResponse(ErrorLocationUnknown);
                    break;
                 
            }
            
            return response;
        }

        /// <summary>
        ///  Gets location of specific address.
        /// </summary>
        /// <param name="address">string containing a specific address</param>
        /// <returns>JSON string PositionResponse</returns>
        private static async Task<string> GetLocationFromAddressInternalAsync(AddressParam address)
        {
            string response = string.Empty;

            // Reverse geocode the specified geographic location.
            MapLocationFinderResult result = await MapLocationFinder.FindLocationsAsync(address.AddressLine, null);

            switch (result.Status)
            {
                case MapLocationFinderStatus.BadLocation:
                    response = PluginBase.ResponseManager.CreateErrorResponse(ErrorGeocodeConverter);
                    break;

                case MapLocationFinderStatus.Success:

                    if (result.Locations != null && result.Locations.Count > 0)
                    {
                        Position newPosition = new Position()
                        {
                            Accuracy = -1,
                            Latitude = result.Locations[0].Point.Position.Latitude,
                            Longitude = result.Locations[0].Point.Position.Longitude,
                            Altitude = (int)result.Locations[0].Point.Position.Altitude
                        };

                        response = PluginBase.ResponseManager.CreateSuccessResponse(newPosition);
                    }
                    else
                    {
                        response = PluginBase.ResponseManager.CreateErrorResponse(ErrorDirectLocationUnknown);
                    }
                       
                    break;

                default:
                    response = PluginBase.ResponseManager.CreateErrorResponse(ErrorDirectLocationUnknown);
                    break;
            }

            return response;
        }

        /// <summary>
        /// Starts geolocation watch, and returns OK if it started succesfully or ERROR if not
        /// </summary>
        /// <returns>JSON string MessageResponse</returns>
        private async static Task<string> WatchLocationInternalAsync(long interval)
        {
            DisposeGeolocator();

            string response = PluginBase.ResponseManager.CreateSuccessResponse(PluginBase.Constants.OK);

            try
            {
                // Request permission to access location
                var accessStatus = await Geolocator.RequestAccessAsync();

                switch (accessStatus)
                {
                    case GeolocationAccessStatus.Allowed:

                        geolocator = new Geolocator { DesiredAccuracy = PositionAccuracy.High };

                        if (interval > 0)
                            geolocator.ReportInterval = Convert.ToUInt32(interval);

                        // Subscribe to PositionChanged event to get updated tracking positions
                        geolocator.PositionChanged += OnPositionChanged;
                        break;

                    case GeolocationAccessStatus.Denied:
                        response = PluginBase.ResponseManager.CreateErrorResponse(ErrorTypes.ErrorPermissionDenied);
                        break;

                    case GeolocationAccessStatus.Unspecified:
                        response = PluginBase.ResponseManager.CreateErrorResponse(ErrorLocationUnknown);
                        break;
                }
            }
            catch (Exception)
            {
                response = PluginBase.ResponseManager.CreateErrorResponse(ErrorTypes.ErrorNotAvailable);
            }


            return response;
        }

        /// <summary>
        /// Method to handle OnPositionChanged Event
        /// </summary>
        /// <param name="sender">Geolocator</param>
        /// <param name="e">PositionChangedEventArgs</param>
        private static void OnPositionChanged(Geolocator sender, PositionChangedEventArgs e)
        {

            if (PositionChangedEvent != null)
            {

                PostMessage postMessage = new PostMessage("location", "cellsNativePlugin", "GeolocationPlugin");

                Position newPosition = new Position()
                {
                    Accuracy = (int)e.Position.Coordinate.Accuracy,
                    Latitude = e.Position.Coordinate.Point.Position.Latitude,
                    Longitude = e.Position.Coordinate.Point.Position.Longitude,
                    Altitude = (int)e.Position.Coordinate.Point.Position.Altitude
                };

                postMessage.Payload = newPosition;
                PositionChangedEvent(null, PluginBase.ResponseManager.CreateSuccessResponse(postMessage));
            }
                
            
        }

        /// <summary>
        /// Returns Task with error response
        /// </summary>
        /// <returns>JSON string Response Object</returns>
        private static Task<string> SendErrorAsync(Error error)
        {
            return Task.Run(() =>
            {
                return PluginBase.ResponseManager.CreateErrorResponse(error);
            });
        }

        private static void DisposeGeolocator()
        {
            if (geolocator != null)
            {
                geolocator.PositionChanged -= OnPositionChanged;
                geolocator = null;
            }
        }

        #endregion

        #region public Events
        public static event EventHandler<object> PositionChangedEvent;
        #endregion

        #region Public Methods
        /// <summary>
        /// Call to GetPositionAsync method. 
        /// This method structure is needed to use async calls in Windows Runtime Components
        /// </summary>
        /// <returns>JSON string PositionResponse</returns>
        public static IAsyncOperation<string> GetPositionAsync()
        {
            return GetPositionInternalAsync().AsAsyncOperation();
        }

        /// <summary>
        /// Call to GetAddressAsync method. 
        /// This method structure is needed to use async calls in Windows Runtime Components 
        /// </summary>
        /// <param name="lat"> latitude </param>
        /// <param name="lon"> longitude </param>
        /// <returns>JSON string AddressResponse</returns>
        public static IAsyncOperation<string> GetAddressAsync(string location)
        {
            LocationParam locationParam = Serialization.Deserialize<LocationParam>(location);

            if (locationParam == null)
                return SendErrorAsync(ErrorTypes.ErrorMalformedParam).AsAsyncOperation();
            else if (locationParam.Latitude == 0 || locationParam.Longitude == 0)
                return SendErrorAsync(ErrorLatLongEmpty).AsAsyncOperation();

            return GetAddressInternalAsync(locationParam).AsAsyncOperation();     
      }

        /// <summary>
        /// Call to GetAddressAsync method. 
        /// This method structure is needed to use async calls in Windows Runtime Components 
        /// </summary>
        /// <param name="address">specific address</param>
        /// <returns>JSON string PositionResponse</returns>
        public static IAsyncOperation<string> GetLocationFromAddressAsync(string address)
        {
            AddressParam addressParam = Serialization.Deserialize<AddressParam>(address);

            if (addressParam == null || (string.IsNullOrEmpty(addressParam.AddressLine)))//VALIDATE PARAMS
                return SendErrorAsync(ErrorTypes.ErrorMalformedParam).AsAsyncOperation();

            return GetLocationFromAddressInternalAsync(addressParam).AsAsyncOperation();
        }

        /// <summary>
        /// Starts geolocation watch asynchronously
        /// </summary>
        /// <returns>JSON string MessageResponse</returns>
        public static IAsyncOperation<string> WatchLocationAsync(string interval)
        {
            WatchLocationParam watchLocationParam = Serialization.Deserialize<WatchLocationParam>(interval);

            long watchInterval = 0;

            if (watchLocationParam != null)
                watchInterval = watchLocationParam.interval;

            return WatchLocationInternalAsync(watchInterval).AsAsyncOperation();
        }

        /// <summary>
        /// Stops geolocation watch
        /// </summary>
        /// <returns>return JSON String MessageResponse</returns>
        public static string ClearWatchLocation()
        {
            DisposeGeolocator();
            return PluginBase.ResponseManager.CreateSuccessResponse(PluginBase.Constants.OK);
        }


        /// <summary>
        /// Shows geolocation settings
        /// </summary>
        /// <returns>return JSON String MessageResponse</returns>
        public static IAsyncOperation<string> PromptForLocationServiceAsync()
        {
            return PromptForLocationServiceInternalAsync().AsAsyncOperation();

        }




        #endregion

    }

}
