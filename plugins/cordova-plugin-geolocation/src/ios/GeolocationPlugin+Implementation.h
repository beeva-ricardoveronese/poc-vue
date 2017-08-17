//
//  GeolocationPlugin+Implementation.h
//  Geolocation
//
//  Created by Medianet Sofia Swidarowicz on 21/3/16.
//
//

#import "GeolocationPlugin.h"

@interface GeolocationPlugin (Implementation)

- (void)openSettingsWithCompletionHandler:(void (^)(NSDictionary *dictResult))completionBlock;
- (void)getDataForLocation:(CDVInvokedUrlCommand *)innerCommand withBlock:(void (^)(BOOL success, NSDictionary *dictionary))block;
- (void)getLocationFromAddress:(CDVInvokedUrlCommand *)innerCommand withBlock:(void (^)(BOOL success, NSDictionary *dictionary))block;
- (void)clearWatchLocationWithCompletionHandler:(void (^)(NSDictionary *resultDict))completionBlock;
- (void)watchLocation:(CDVInvokedUrlCommand *) innerCommand withManager:(CLLocationManager *)manager completionHandler:(void (^)(NSDictionary *dictResult))completionBlock;

@end
