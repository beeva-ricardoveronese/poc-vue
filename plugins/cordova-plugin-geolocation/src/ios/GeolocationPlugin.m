/********* GeolocationPlugin.m Cordova Plugin Implementation *******/

#import "GeolocationPlugin.h"
#import <CoreLocation/CoreLocation.h>
#import "GeolocationPlugin+Implementation.h"

NSString *const kLocationLatitude            = @"latitude";
NSString *const kLocationLongitude           = @"longitude";
NSString *const kLocationAltitude            = @"altitude";
NSString *const kLocationHorizontalAccuracy  = @"horizontal_accuracy";
NSString *const kLocationVerticalAccuracy    = @"vertical_accuracy";
NSString *const kLocationAccuracy            = @"accuracy";
NSString *const kLocationAddress             = @"address";
NSString *const kLocationAddressLine         = @"addressLine";

NSString *const kAppleAddressFormattedString = @"FormattedAddressLines";

NSString *const kLocationResponse            = @"locationResponse";
NSString *const kLocationWatcherResponse     = @"watcherResponse";

NSString *const kInterval                    = @"interval";

#define ACTION_LOCATION_DID_UPDATE @"location"

@interface GeolocationPlugin () <CLLocationManagerDelegate>

@property (nonatomic, strong) CDVInvokedUrlCommand *innerCommand;

@end

@implementation GeolocationPlugin


/**
 *  Initiliazer for Plugin Command class.
 *
 *  @param command Cordova Command
 *  @param message Int value that indicates the type of data passed (Dictionary, String, Array, Int, Bool)
 *  @param dict    contains the data sended to index.js
 */

- (void)sendResult:(CDVInvokedUrlCommand *)command withTypeMessage:(int)message andDict:(NSDictionary*)dict {
    if(!self.pluginCommand){
        self.pluginCommand = [super initWithCommandPlugin:command];
    }

    [self.pluginCommand sendPluginCommand:command type:message andDict:dict];
}


/**
 *  Plugin initialization. Only instanciate the CLLocationManager object and set the delegate
 */
- (void)pluginInitialize{
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManagerWatchPostion = [[CLLocationManager alloc] init];
    self.locationManagerWatchPostion.delegate = self;
    
}

- (void)promptForLocationService:(CDVInvokedUrlCommand *)command {
    
    self.innerCommand = command;
    __weak GeolocationPlugin *weakSelf = self;
    
    [self runInBackground:^{
        
        [weakSelf openSettingsWithCompletionHandler:^(NSDictionary *resultDict) {
            
            if (resultDict[SUCCESS]) {
                
                [weakSelf sendResult:weakSelf.innerCommand withTypeMessage:MessageString andDict:resultDict];
                
            }else{
                
                [weakSelf sendResult:weakSelf.innerCommand withTypeMessage:MessageErrorDict andDict:resultDict];
                
            }
            
        }];
        
        
    }];
    
}

/**
 *  Method to clear an observer to a location manager.
 *
 *  @param command Cordova command.
 */
- (void)clearWatchLocation:(CDVInvokedUrlCommand *)command {
    
    self.innerCommand = command;
    __weak GeolocationPlugin *weakSelf = self;
    
    [self runInBackground:^{
        
        [weakSelf clearWatchLocationWithCompletionHandler:^(NSDictionary *resultDict) {
            
            if (resultDict[SUCCESS]) {
                
                [weakSelf sendResult:weakSelf.innerCommand withTypeMessage:MessageString andDict:resultDict];
                
            }else{
                
                [weakSelf sendResult:weakSelf.innerCommand withTypeMessage:MessageErrorDict andDict:resultDict];
                
            }
            
        }];
        
        
    }];
    
}

/**
 *  Method to add an observer to a location manager.
 *
 *  @param command Cordova command.
 */
- (void)watchLocation:(CDVInvokedUrlCommand *)command {
    
    self.innerCommand = command;
    
    __weak GeolocationPlugin *weakSelf = self;
    
    [self runInBackground:^{
                
        [weakSelf watchLocation:weakSelf.innerCommand withManager:weakSelf.locationManagerWatchPostion completionHandler:^(NSDictionary *resultDict) {
            
            
            if (resultDict[SUCCESS]) {
                
                [weakSelf sendResult:weakSelf.innerCommand withTypeMessage:MessageString andDict:resultDict];
            
            } else if(resultDict[kLocationWatcherResponse]){
                
                [weakSelf postMessageWithPluginName:NSStringFromClass([weakSelf class]) action:ACTION_LOCATION_DID_UPDATE payload:resultDict[kLocationWatcherResponse]];
            
            }else{
                
                [weakSelf sendResult:weakSelf.innerCommand withTypeMessage:MessageErrorDict andDict:resultDict];
                
            }
            
        }];
        
        
    }];
    
}

/**
 *  Method to get the current position of the device.
 *
 *  @param command Cordova command without arguments.
 */
- (void)getCurrentPosition:(CDVInvokedUrlCommand *)command {
    
    self.innerCommand = command;
    
    GeolocationPlugin __weak* weakSelf = self;
   
    // Everything lauching on js interface methods must be in background
    [self runInBackground:^{
        
        [weakSelf watchLocation:weakSelf.innerCommand withManager:weakSelf.locationManager completionHandler:^(NSDictionary *dictResult) {
            
            if(dictResult[SUCCESS]){
                //dictResult will contains the location information
                [weakSelf sendResult:weakSelf.innerCommand withTypeMessage:MessageDict andDict:dictResult[kLocationResponse]];
                
            }else{
                //it's an error.
                [weakSelf sendResult:weakSelf.innerCommand withTypeMessage:MessageErrorDict andDict:dictResult];
                
            }
            
        }];
        
    }];
    
}

/**
 *  Method to get the address as String from a location given by getCurrentPosition: method
 *
 *  @param command Cordova command. Only one argument with the location dictionary as is given in the method getCurrentPosition:
 */
- (void)getAddressFromLocation:(CDVInvokedUrlCommand *)command{

    self.innerCommand = command;
    
    GeolocationPlugin __weak* weakSelf = self;
    
    // Everything lauching on js interface methods must be in background
    [self runInBackground:^{

        [weakSelf getDataForLocation:weakSelf.innerCommand withBlock:^(BOOL success, NSDictionary *dictionary) {
            
           if (dictionary[RESPONSE_CODE]){
                
                [weakSelf sendResult:command withTypeMessage:MessageErrorDict andDict:dictionary];
            
            }else {
                
                [weakSelf sendResult:command withTypeMessage:MessageDict andDict:dictionary];
            
            }
            
        }];
    }];

}

/**
 *  Method to get the location (latitude, longitude, accuracy and altitude) as NSDictionary from an address given as NSString
 *
 *  @param command Cordova command. Only one argument with the address dictionary with the next format @{"addressLine": "Gran Via, Madrid "}
 */
- (void)getLocationFromAddress:(CDVInvokedUrlCommand *)command {

    self.innerCommand = command;
    
    GeolocationPlugin __weak* weakSelf = self;
    
    // Everything lauching on js interface methods must be in background
    [self runInBackground:^{
        
        [weakSelf getLocationFromAddress:command withBlock:^(BOOL success, NSDictionary *dictionary) {
            
            if (dictionary[RESPONSE_CODE]){
                
                [weakSelf sendResult:command withTypeMessage:MessageErrorDict andDict:dictionary];
                
            }else {
                
                [weakSelf sendResult:command withTypeMessage:MessageDict andDict:dictionary];
                
            }
            
        }];
         
    }];
    
}

@end
