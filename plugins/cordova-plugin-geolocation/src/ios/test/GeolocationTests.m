//
//  GeolocationTests.m
//  GeolocationTests
//
//  Created by Medianet Sofia Swidarowicz on 21/3/16.
//
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "CordovaBase.h"
#import "CDVPluginResult+CordovaBase.h"
#import <Cordova/CDVCommandDelegateImpl.h>
#import "GeolocationPlugin.h"
#import "GeolocationPlugin+Implementation.h"
#import <CoreLocation/CoreLocation.h>


static NSString *className = @"Geolocation";


@interface GeolocationTests : XCTestCase
@property (nonatomic) GeolocationPlugin *geolocationPlugin;
@end

@interface GeolocationPlugin(){
    
    
    
}
- (void)getLocationFromAddress:(CDVInvokedUrlCommand *)command;
- (void)getAddressFromLocation:(CDVInvokedUrlCommand *)command;
- (void)getCurrentPosition:(CDVInvokedUrlCommand *)command;
- (void)clearWatchLocation:(CDVInvokedUrlCommand *)command;
- (void)watchLocation:(CDVInvokedUrlCommand *)command;
- (void)promptForLocationService:(CDVInvokedUrlCommand *)command;
@end

@implementation GeolocationTests

- (void)setUp {
    [super setUp];
    self.geolocationPlugin = [[GeolocationPlugin alloc]init];
    [self timerForTestWithSeconds:1];
}

- (void)testPrompt{
    NSArray *args       = @[];
    
    CDVInvokedUrlCommand *command = [self setCommandWithMethod:@"promptForLocationService" arguments:args];
    [self.geolocationPlugin promptForLocationService:command];
    //help us to wait for the block in main method to finish
    [self timerForTestWithSeconds:1];
    
    __weak GeolocationTests *weakSelf = self;
    
    [self.geolocationPlugin openSettingsWithCompletionHandler:^(NSDictionary *dictResult) {
        
        DDLogInfo(@"%@ ", dictResult);
        
        CDVPluginResult *pluginResult = [weakSelf.geolocationPlugin.pluginCommand messageForPluginWithCommand:command andType:MessageDict andResult:dictResult];
        [weakSelf testBlockAssertTrue:pluginResult withClassName:NSStringFromSelector(_cmd)];
        
    }];
    
    
}



- (void)testGetCurrentPosition{
    NSArray *args       = @[];
    
    CDVInvokedUrlCommand *command = [self setCommandWithMethod:@"getCurrentPosition" arguments:args];
    [self.geolocationPlugin getCurrentPosition:command];
    //help us to wait for the block in main method to finish
    [self timerForTestWithSeconds:1];
    
    __weak GeolocationTests *weakSelf = self;
    
    [self.geolocationPlugin watchLocation:command withManager:self.geolocationPlugin.locationManager completionHandler:^(NSDictionary *dictResult) {
        
        DDLogInfo(@"%@ ", dictResult);
        
        CDVPluginResult *pluginResult = [weakSelf.geolocationPlugin.pluginCommand messageForPluginWithCommand:command andType:MessageDict andResult:dictResult];
        [weakSelf testBlockAssertTrue:pluginResult withClassName:NSStringFromSelector(_cmd)];
        
    }];
    
    
}

- (void)testGetAddressFromLocationError{
    NSArray *args       = @[];
    CDVInvokedUrlCommand *command = [self setCommandWithMethod:@"getAddressFromLocation" arguments:args];
    [self.geolocationPlugin getAddressFromLocation:command];
    //help us to wait for the block in main method to finish
    [self timerForTestWithSeconds:1];
    
    __weak GeolocationTests *weakSelf = self;
    
    [self.geolocationPlugin getDataForLocation:command withBlock:^(BOOL success, NSDictionary *dictionary) {
        
        DDLogInfo(@"%@ ", dictionary);
        
        CDVPluginResult *pluginResult = [weakSelf.geolocationPlugin.pluginCommand messageForPluginWithCommand:command andType:MessageErrorDict andResult:dictionary];
        [weakSelf testBlockAssertTrue:pluginResult withClassName:NSStringFromSelector(_cmd)];
        
    }];
    
    [self timerForTestWithSeconds:1];
}

- (void)testGetAddressFromLocationSuccess{
    NSArray *args       = @[@{@"altitude":@0,
                              @"horizontal_accuracy":@5,
                              @"latitude":@"40.48158919535051",
                              @"longitude":@"-3.703025579452515",
                              @"vertical_accuracy":@"-1"}];
    CDVInvokedUrlCommand *command = [self setCommandWithMethod:@"getAddressFromLocation" arguments:args];
    [self.geolocationPlugin getAddressFromLocation:command];
    //help us to wait for the block in main method to finish
    [self timerForTestWithSeconds:1];
    
    __weak GeolocationTests *weakSelf = self;
    
    [self.geolocationPlugin getDataForLocation:command withBlock:^(BOOL success, NSDictionary *dictionary) {
        
        DDLogInfo(@"%@ ", dictionary);
        
        CDVPluginResult *pluginResult = [weakSelf.geolocationPlugin.pluginCommand messageForPluginWithCommand:command andType:MessageDict andResult:dictionary];
        [weakSelf testBlockAssertTrue:pluginResult withClassName:NSStringFromSelector(_cmd)];
        
    }];
    
    [self timerForTestWithSeconds:1];
}

- (void)testGetLocationFromAddressSuccess{
    
    NSArray *args       = @[@{kLocationAddressLine:@"Gran Via, Madrid "}];
    
    CDVInvokedUrlCommand *command = [self setCommandWithMethod:@"getLocationFromAddress" arguments:args];
    [self.geolocationPlugin getLocationFromAddress:command];
    //help us to wait for the block in main method to finish
    [self timerForTestWithSeconds:1];
    
    __weak GeolocationTests *weakSelf = self;
    
    [self.geolocationPlugin getLocationFromAddress:command withBlock:^(BOOL success, NSDictionary *dictionary) {
        
        DDLogInfo(@"%@ ", dictionary);
        
        CDVPluginResult *pluginResult = [weakSelf.geolocationPlugin.pluginCommand messageForPluginWithCommand:command andType:MessageDict andResult:dictionary];
        [weakSelf testBlockAssertTrue:pluginResult withClassName:NSStringFromSelector(_cmd)];
        
    }];
    
    [self timerForTestWithSeconds:1];
    
}

- (void)testClearWatchLocation {
    
    NSArray *args = @[];
    CDVInvokedUrlCommand *command = [self setCommandWithMethod:@"clearWatchLocation" arguments:args];
    [self.geolocationPlugin clearWatchLocation:command];
    //help us to wait for the block in main method to finish
    [self timerForTestWithSeconds:1];
    
    __weak GeolocationTests *weakSelf = self;
    
    [self.geolocationPlugin clearWatchLocationWithCompletionHandler:^(NSDictionary *resultDict) {
        
        CDVPluginResult *pluginResult = [weakSelf.geolocationPlugin.pluginCommand messageForPluginWithCommand:command andType:MessageString andResult:resultDict];
        [weakSelf testBlockAssertTrue:pluginResult withClassName:NSStringFromSelector(_cmd)];
        
    }];
    
}

- (void)testWatchLocation{
    NSArray *args       = @[];
    
    CDVInvokedUrlCommand *command = [self setCommandWithMethod:@"watchLocation" arguments:args];
    [self.geolocationPlugin watchLocation:command];
    //help us to wait for the block in main method to finish
    [self timerForTestWithSeconds:1];
    
    __weak GeolocationTests *weakSelf = self;
    
    [self.geolocationPlugin watchLocation:command withManager:self.geolocationPlugin.locationManagerWatchPostion completionHandler:^(NSDictionary *dictResult) {
        
        DDLogInfo(@"%@ ", dictResult);
        
        CDVPluginResult *pluginResult = [weakSelf.geolocationPlugin.pluginCommand messageForPluginWithCommand:command andType:MessageDict andResult:dictResult];
        [weakSelf testBlockAssertTrue:pluginResult withClassName:NSStringFromSelector(_cmd)];
        
    }];
    
    
}

- (void)testWatchLocationWithInterval{
    NSArray *args       = @[@{kInterval:@3000}];
    
    CDVInvokedUrlCommand *command = [self setCommandWithMethod:@"watchLocation" arguments:args];
    [self.geolocationPlugin watchLocation:command];
    //help us to wait for the block in main method to finish
    [self timerForTestWithSeconds:1];
    
    __weak GeolocationTests *weakSelf = self;
    
    [self.geolocationPlugin watchLocation:command withManager:self.geolocationPlugin.locationManagerWatchPostion completionHandler:^(NSDictionary *dictResult) {
        
        DDLogInfo(@"%@ ", dictResult);
        
        CDVPluginResult *pluginResult = [weakSelf.geolocationPlugin.pluginCommand messageForPluginWithCommand:command andType:MessageDict andResult:dictResult];
        [weakSelf testBlockAssertTrue:pluginResult withClassName:NSStringFromSelector(_cmd)];
        
    }];
    
    
}

#pragma mark - Auxiliary Methods

/**
 *  A timer used to make a loop to wait for all values to get set correctly
 *
 *  @param seconds int value
 */
- (void)timerForTestWithSeconds:(int)seconds{
    NSDate *start = [NSDate date];
    
    while (-[start timeIntervalSinceNow] < seconds) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:seconds]];
    }
}



/**
 *  Setter for command
 *
 *  @param method name
 *  @param args  array with external arguments
 *
 *  @return object CDVInvokedUrlCommand
 */

- (CDVInvokedUrlCommand*)setCommandWithMethod:(NSString*)method arguments:(NSArray*)args{
    return [[CDVInvokedUrlCommand alloc] initWithArguments:args
                                                callbackId:className
                                                 className:className
                                                methodName:method];
}

/**
 *  Common asserts method  when results are true
 *
 *  @param pluginResult CDVPluginResult mocked
 *  @param class        test class name to get logged
 */

- (void)testBlockAssertTrue:(CDVPluginResult *)pluginResult withClassName:(NSString*)class{
    DDLogInfo(@" %@ for assert true .........................", class);
    DDLogInfo(@"pluginResult message %@ \n, pluginResult.status %@, pluginResult.keepCallback %@ , pluginResult %@", pluginResult.message, pluginResult.status, pluginResult.keepCallback, pluginResult);
    
    
    DDLogInfo(@"pluginResult message1 %@ , pluginResult.status1 %@, pluginResult.keepCallback1 %@ , pluginResult1 %@", self.geolocationPlugin.pluginResult.message, self.geolocationPlugin.pluginResult.status, self.geolocationPlugin.pluginResult.keepCallback, self.geolocationPlugin.pluginResult);
    
    XCTAssertTrue([self.geolocationPlugin.pluginResult isEqualClassCDVPluginResult:pluginResult], @"Error Assert results are not equal for class %@",class);
}

/**
 *  Common asserts method when results are false
 *
 *  @param pluginResult CDVPluginResult mocked
 *  @param class        test class name to get logged
 */

- (void)testBlockAssertFalse:(CDVPluginResult *)pluginResult withClassName:(NSString*)class{
    DDLogInfo(@" %@ for assert false .........................", class);
    DDLogInfo(@"pluginResult message3 %@ , pluginResult.status3 %@, pluginResult.keepCallback3 %@ , pluginResult3 %@", pluginResult.message, pluginResult.status, pluginResult.keepCallback, pluginResult);
    
    
    DDLogInfo(@"pluginResult message1 %@ , pluginResult.status1 %@, pluginResult.keepCallback1 %@ , pluginResult1 %@", self.geolocationPlugin.pluginResult.message, self.geolocationPlugin.pluginResult.status, self.geolocationPlugin.pluginResult.keepCallback, self.geolocationPlugin.pluginResult);
    
    XCTAssertFalse([self.geolocationPlugin.pluginResult isEqualClassCDVPluginResult:pluginResult], @"Error Assert: object expected is not correct");
}

@end
