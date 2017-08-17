//
//  CDVPluginResult+CordovaBase.h
//  deviceInfo
//
//  Created by Medianet Sofia Swidarowicz on 22/2/16.
//
//

#import <Cordova/CDV.h>


@interface CDVPluginResult (CordovaBase)

- (BOOL)isEqualClassCDVPluginResult:(CDVPluginResult*)result;

@end
