//
//  CDVPluginResult+CordovaBase.m
//  deviceInfo
//
//  Created by Medianet Sofia Swidarowicz on 22/2/16.
//
//

#import "CDVPluginResult+CordovaBase.h"
#import "CordovaBase.h"

@implementation CDVPluginResult (CordovaBase)


- (BOOL)isEqualClassCDVPluginResult:(CDVPluginResult*)result{

    if ((result.status == self.status) && ([result.message isEqual:self.message])){
        NSLog(@"ARE EQUAL.....");
        return YES;
    }
    NSLog(@"AREN'T EQUAL.....");
    return NO;
}



@end
