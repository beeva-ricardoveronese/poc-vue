//
//  GeolocationPlugin+Implementation.m
//  Geolocation
//
//  Created by Medianet Sofia Swidarowicz on 21/3/16.
//
//

#import "GeolocationPlugin+Implementation.h"
#import <CoreLocation/CoreLocation.h>
#import "ConstantsGeolocationPlugin.h"
#import <objc/runtime.h>

#define kConversionFactorSeconds 1000


@implementation GeolocationPlugin (Implementation)


-(void) openSettingsWithCompletionHandler:(void (^)(NSDictionary *dictResult))completionBlock{
    
    self.permisionRequestedByPrompMethod = YES;
    self.promptCompletionHandler = completionBlock;
    
    //Request permission if is not determinated
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
    } else {
        
        [self openSettingsOnAutorizationStatusSet];
    }
    
    
}

-(void) openSettingsOnAutorizationStatusSet{
    
    self.permisionRequestedByPrompMethod = NO;
    
    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    __block  NSDictionary *resultDict;
    
    if ([[UIApplication sharedApplication] canOpenURL:settingsURL]){
        
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]){
            [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:^(BOOL success) {
                
                if (success){
                    resultDict = @{SUCCESS: SUCCESS_MESSAGE};
                }
                else {
                    resultDict = @{RESPONSE_CODE:@(ERROR_DEFAULT.integerValue), RESPONSE_MESSAGE:kErrorMessage_Prompt};
                }
                
                self.promptCompletionHandler(resultDict);
                
            }];
        } else {
            [[UIApplication sharedApplication] openURL:settingsURL];
            resultDict = @{SUCCESS: SUCCESS_MESSAGE};
            self.promptCompletionHandler(resultDict);
        }
        
#else
        [[UIApplication sharedApplication] openURL:settingsURL];
        resultDict = @{SUCCESS: SUCCESS_MESSAGE};
        self.promptCompletionHandler(resultDict);
#endif
        
    }
    
}

/**
 *  Method to solve this native action. Only stops locationmanager updates, and returns a Success.
 *
 *  @param completionBlock <#completionBlock description#>
 */
- (void)clearWatchLocationWithCompletionHandler:(void (^)(NSDictionary *dictResult))completionBlock{
    
    //Stops both timer and location update
    [self stopUpdatingLocationWithInterval];
    
    completionBlock(@{SUCCESS:SUCCESS_MESSAGE});

}

/**
 *  Method to solve this native action. Launch the locationManager updates for getCurrentPosition and for watchLocation methods.
 *
 *  @param manager          CLLocationManager object that returns the CLLocation objects updated.
 *  @param completionBlock  Code block to execute when delegate methods respond.
 */
- (void)watchLocation:(CDVInvokedUrlCommand *)innerCommand withManager:(CLLocationManager *)manager completionHandler:(void (^)(NSDictionary *dictResult))completionBlock{
    
    if ([manager isEqual:self.locationManager]){
        
        self.completionHandler = completionBlock;
        
    }else{
        
        self.completionHandlerWatchLocation = completionBlock;

        [self stopUpdatingLocationWithInterval];
        
        NSDictionary *dictInterval = [[innerCommand arguments] firstObject];
        
        if (dictInterval && [dictInterval respondsToSelector:@selector(objectForKey:)]) {
            self.interval =  [[dictInterval objectForKey:kInterval]longValue] / kConversionFactorSeconds;
        }
        
    }
    
    [self initializeLocationManager:manager];

}

/**
 *  Method to solve this native action. Returns Address literal with a given NSDictionary with a location.
 *
 *  @param innerCommand Cordova Command that contains the NSDictionary with the Location given.
 *  @param block        Code block to execute when the address literal is given.
 */
- (void)getDataForLocation:(CDVInvokedUrlCommand *)innerCommand withBlock:(void (^)(BOOL success, NSDictionary *dictionary))block{

    NSDictionary *dictLocation = [[innerCommand arguments] firstObject];

    if (dictLocation && [dictLocation respondsToSelector:@selector(objectForKey:)]) {
    
        NSNumber *latitude         = [dictLocation objectForKey:kLocationLatitude];
        NSNumber *longitude        = [dictLocation objectForKey:kLocationLongitude];
        NSNumber *altitude         = [dictLocation objectForKey:kLocationAltitude];
        
        CLLocation *location = [self findLocation:dictLocation locationLatitude:latitude locationLongitude:longitude locationAltitude:altitude];
        [self reverseGeocodeConverter:location geoLatitude:latitude geoLongitude:longitude withBlock:^(BOOL success, NSDictionary *dictionary) {
            block(YES, dictionary);
        }];
                
    } else {
        
        block(NO, @{RESPONSE_CODE:@(ERROR_MALFORMED_PARAMS.integerValue), RESPONSE_MESSAGE:kErrorMessage_MalformedParams});
        
    }

 }

/**
 *  Method to solve this native action. Returns Location as Dictionary with a given String with an address.
 *
 *  @param innerCommand Cordova Command that contains the String with the address given.
 *  @param block        Code block to execute when the location dictionary is given.
 */
- (void)getLocationFromAddress:(CDVInvokedUrlCommand *)innerCommand withBlock:(void (^)(BOOL success, NSDictionary *dictionary))block{
    
    NSDictionary *dictLocation = [[innerCommand arguments] firstObject];
    
    if (dictLocation && [dictLocation respondsToSelector:@selector(objectForKey:)]) {
        
        NSString *strAddress = [dictLocation objectForKey:kLocationAddressLine];
        
        if (strAddress && [strAddress respondsToSelector:@selector(length)] && ![strAddress isEqualToString:@""]){
            
            [self geocodeConverter:strAddress withCompletionBlock:^(BOOL success, NSDictionary *dictResult){
                
                block(success, dictResult);
                
            }];
            
        }else{
            
            block(NO, @{RESPONSE_CODE:@(ERROR_MALFORMED_PARAMS.integerValue), RESPONSE_MESSAGE:kErrorMessage_MalformedParams});
            
        }
        
    }else{
        
        block(NO, @{RESPONSE_CODE:@(ERROR_MALFORMED_PARAMS.integerValue), RESPONSE_MESSAGE:kErrorMessage_MalformedParams});
        
    }

}

/**
 *  Returns a CLLocation object with a given latitude, longitude, altitude and accuracy.
 *
 *  @param dictLocation NSDictionary with all the information for the CLLocation
 *  @param latitude     NSNumber with the latitude of the CLLocation
 *  @param longitude    NSNumber with the longitude of the CLLocation
 *  @param altitude     NSNumber with the altitude of the CLLocation
 *
 *  @return CLLocation Object with the given data.
 */
- (CLLocation *)findLocation:(NSDictionary *)dictLocation locationLatitude:(NSNumber *)latitude locationLongitude:(NSNumber *)longitude locationAltitude:(NSNumber *)altitude{


    NSNumber *accuracy;
    NSNumber *vAccuracy;
    NSNumber *hAccuracy;

    CLLocation *location;


    if ([dictLocation objectForKey:kLocationAccuracy]) {

        accuracy = [dictLocation objectForKey:kLocationAccuracy];

        location = [self getLocationWithVerticalAccuracy:accuracy horizontalAccuracy:accuracy latitude:latitude longitude:longitude altitude:altitude];

    } else {

        vAccuracy        = [dictLocation objectForKey:kLocationVerticalAccuracy];
        hAccuracy        = [dictLocation objectForKey:kLocationHorizontalAccuracy];

        location = [self getLocationWithVerticalAccuracy:vAccuracy horizontalAccuracy:hAccuracy latitude:latitude longitude:longitude altitude:altitude];
        
    }
    return location;
}

/**
 *  This method returns a dictionary with the address given a CLLocation.
 *
 *  @param location  CLLocation used to get an address
 *  @param latitude  NSNumber with the latitude of the CLLocation
 *  @param longitude NSNumber with the longitude of the CLLocation
 *  @param block     Code block that will be execute at the end of the method, when success or failure take place.
 */
- (void)reverseGeocodeConverter:(CLLocation *)location geoLatitude:(NSNumber *)latitude geoLongitude:(NSNumber *)longitude withBlock:(void (^)(BOOL success, NSDictionary *dictionary))block{

    CLGeocoder *geocoderConverter = [[CLGeocoder alloc] init];
    __block NSDictionary *dict = @{};

    [geocoderConverter reverseGeocodeLocation:location completionHandler:^(NSArray* placemarks, NSError * error) {

        if (error) {

            dict = @{RESPONSE_CODE:@(kErrorCode_GeocodeConverterError.integerValue), RESPONSE_MESSAGE:kErrorMessage_GeocodeConverterError};
            block(NO, dict);

        }else{

            // Mute the array "FormattedAddressLines" into only one string.
            NSArray *addressArray = [[[placemarks firstObject] addressDictionary] objectForKey:kAppleAddressFormattedString];
            NSString *strAddressResult = @"";
            for (NSString *addressSubstring in addressArray) {

                strAddressResult = [strAddressResult stringByAppendingString:addressSubstring];
                strAddressResult = [strAddressResult stringByAppendingString:@" "];

            }

            if (!latitude || !longitude){
                dict = @{RESPONSE_CODE:@(kErrorCode_LocationValuesEmpty.integerValue), RESPONSE_MESSAGE:kErrorMessage_LocationValuesEmpty};
            }else{
                dict = @{kLocationAddress: @[@{kLocationLatitude: latitude,
                                               kLocationLongitude: longitude,
                                               kLocationAddressLine: strAddressResult}]};
            }

           block(YES, dict);

        }

    }];
}

- (void)geocodeConverter:(NSString *)strAddress withCompletionBlock:(void (^)(BOOL success, NSDictionary * dictResutl))completionBlock{

    CLGeocoder *geocodeConverter = [[CLGeocoder alloc] init];
    __block NSDictionary *dict = @{};
    
    [geocodeConverter geocodeAddressString:strAddress completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error) {
            
            dict = @{RESPONSE_CODE:@(kErrorCode_GeocodeConverterError.integerValue), RESPONSE_MESSAGE:kErrorMessage_GeocodeConverterError};
            completionBlock(NO, dict);
            
        }else{
            
            if ([placemarks count] > 0) {
                
                CLLocation *location = [[placemarks firstObject] location];
                
                if (location) {
                    dict = @{kLocationLatitude:@(location.coordinate.latitude),
                             kLocationLongitude:@(location.coordinate.longitude),
                             kLocationAltitude:@(location.altitude),
                             kLocationAccuracy:@(location.horizontalAccuracy)};
                    
                    completionBlock(YES, dict);
                }
                
            }else{
            
                dict = @{RESPONSE_CODE:kErrorCode_LocationUnableToRetrieveLocation,
                         RESPONSE_MESSAGE: kErrorMessage_LocationUnableToRetrieveLocation};
                
                completionBlock(NO, dict);
            }
            
        }
        
    }];
    
}


/**
 *  CLLocation instance generator
 *
 *  @param vAccuracy Vertical Accuracy for CLLocation instance.
 *  @param hAccuracy Horizontal Accuracy for CLLocation instance.
 *  @param latitude  Latitude value for CLLocation instance.
 *  @param longitude Longitude value for CLLocation instance.
 *  @param altitude  Altitude value for CLLocation instance.
 *
 *  @return CLLocation object instance.
 */
- (CLLocation *)getLocationWithVerticalAccuracy:(NSNumber *)vAccuracy horizontalAccuracy:(NSNumber *)hAccuracy latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude altitude:(NSNumber *)altitude{


     return [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue) altitude:altitude.doubleValue horizontalAccuracy:hAccuracy.doubleValue verticalAccuracy:vAccuracy.doubleValue timestamp:[NSDate date]];

}

#pragma mark - CLLocationManagerDelegate

/**
 *  CLLocationManagerDelegate method to manage the errors given by location manager.
 *
 *  @param manager CLLocationManager that brings the error.
 *  @param error   NSError brought.
 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSDictionary *dict = @{RESPONSE_CODE:@(ERROR_DEFAULT.integerValue), RESPONSE_MESSAGE:[error description]};
    
    switch (error.code) {
        case kCLErrorLocationUnknown:
        case kCLErrorHeadingFailure:
            dict = @{RESPONSE_CODE:@(kErrorCode_LocationServiceTemporaryUnabled.integerValue), RESPONSE_MESSAGE:kErrorCode_LocationServiceTemporaryUnabled};
            break;
        case kCLErrorDenied:
            dict = @{RESPONSE_CODE:@(ERROR_PERMISSION_DENIED.integerValue), RESPONSE_MESSAGE:kErrorMessage_LocationPermissionDisabled};
            break;
    }
    
    if ([manager isEqual:self.locationManager]) {
        
        self.completionHandler(dict);
        
    }else{
        
        self.completionHandlerWatchLocation(dict);
        
    }
    
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (self.permisionRequestedByPrompMethod && ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusNotDetermined)) {
        [self openSettingsOnAutorizationStatusSet];
    }
    
}

/**
 *  CLLocationManagerDelegate method to manage the updates of locations of the manager.
 *
 *  @param manager   CLLocationManager that updates the location.
 *  @param locations NSArray of locations updated.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    if ((locations && [locations count] > 0 && [manager isEqual:self.locationManager]) || [manager isEqual:self.locationManagerWatchPostion]) {
        
        CLLocation *location = [locations lastObject];
        
        NSDictionary *dictLocationData = @{kLocationLatitude: [NSNumber numberWithDouble:location.coordinate.latitude],
                                           kLocationLongitude: [NSNumber numberWithDouble:location.coordinate.longitude],
                                           kLocationAltitude: [NSNumber numberWithDouble:location.altitude],
                                           kLocationAccuracy: [NSNumber numberWithDouble:location.horizontalAccuracy]};
        
        
        //locationManagerWatchPostion with interval responses will be handled with updateLocation method.
        //Otherwise, postmessage will be sent
        if ([manager isEqual:self.locationManagerWatchPostion] && ![self hasInterval]){
            
            self.completionHandlerWatchLocation(@{kLocationWatcherResponse:dictLocationData});
            
        } else if ([manager isEqual:self.locationManager]) {
            
            self.completionHandler(@{SUCCESS:SUCCESS_MESSAGE, kLocationResponse:dictLocationData});
            
            [self.locationManager stopUpdatingLocation];
            
        }
        
    }
    
}

#pragma mark - AuxiliaryMethods

/**
 *  Extra initialization for CLLocationManager
 *
 *  @param manager the manager instance that will be modified.
 */
- (void)initializeLocationManager:(CLLocationManager *)manager {
    
    manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [manager requestWhenInUseAuthorization];
    }
    
    [manager startUpdatingLocation];
    
    if ([self hasInterval]){
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            self.locationWatchTimer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(updateLocation) userInfo:nil repeats:YES];
            
            [self.locationWatchTimer fire];
        });
    }
    
    if ([manager isEqual: self.locationManagerWatchPostion]){
        self.completionHandlerWatchLocation(@{SUCCESS:SUCCESS_MESSAGE});
    }
    
}

- (void)updateLocation {
    CLLocation *location = self.locationManager.location;
    

    NSDictionary *dictLocationData = @{kLocationLatitude: [NSNumber numberWithDouble:location.coordinate.latitude],
                                       kLocationLongitude: [NSNumber numberWithDouble:location.coordinate.longitude],
                                       kLocationAltitude: [NSNumber numberWithDouble:location.altitude],
                                       kLocationAccuracy: [NSNumber numberWithDouble:location.horizontalAccuracy]};
    
     self.completionHandlerWatchLocation(@{kLocationWatcherResponse:dictLocationData});
}



-(void) stopUpdatingLocationWithInterval {
    
    if (self.locationWatchTimer){
        self.interval = 0;
        [self.locationWatchTimer invalidate];
        self.locationWatchTimer = nil;
    }
    
    [self.locationManagerWatchPostion stopUpdatingLocation];
}


-(BOOL)hasInterval {
    return self.interval > 0;
}
@end
