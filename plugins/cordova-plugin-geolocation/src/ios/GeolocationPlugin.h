/********* GeolocationPlugin.h Cordova Plugin Interface *******/

#import "CordovaBase.h"
#import <CoreLocation/CoreLocation.h>


extern NSString * const kLocationLatitude;
extern NSString * const kLocationLongitude;
extern NSString * const kLocationAltitude;
extern NSString * const kLocationHorizontalAccuracy;
extern NSString * const kLocationVerticalAccuracy;
extern NSString * const kLocationAccuracy;
extern NSString * const kLocationAddress;
extern NSString * const kLocationAddressLine;
extern NSString * const kAppleAddressFormattedString;
extern NSString * const kLocationResponse;
extern NSString * const kLocationWatcherResponse;
extern NSString * const kInterval;

@interface GeolocationPlugin : CordovaBase

/**
 *  The location manager that manage the location updates.
 */
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocationManager *locationManagerWatchPostion;

@property (nonatomic, copy, nonnull) void (^completionHandlerWatchLocation)(NSDictionary *resultDict);
@property (nonatomic, copy, nonnull) void (^completionHandler)(NSDictionary  *resultDict);

@property (nonatomic, copy, nonnull) void (^promptCompletionHandler)(NSDictionary  *resultDict);

@property (nonatomic, strong, nullable) NSTimer * locationWatchTimer;

@property (nonatomic, assign) NSTimeInterval interval;

@property (nonatomic, assign) BOOL permisionRequestedByPrompMethod;

@end
