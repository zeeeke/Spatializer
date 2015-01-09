//
//  SPTBluetoothController.m
//  Spatializer
//
//  Created by Zeke Shearer on 1/8/15.
//  Copyright (c) 2015 Zeke Shearer. All rights reserved.
//

#import "SPTBluetoothController.h"
#import "PTDBeanManager.h"

@interface SPTBluetoothController ()<PTDBeanDelegate, PTDBeanManagerDelegate>

@property (nonatomic, strong) PTDBeanManager *beanManager;
@property (nonatomic, strong) PTDBean *bean;
@property (nonatomic, strong) NSString *serialWriteString;
@property (nonatomic, strong) SPTBeanWriteCompletion writeCompletion;
@property (nonatomic, strong) NSTimer *serialWriteDelayTimer;

@end

@implementation SPTBluetoothController

+ (SPTBluetoothController *)instance
{
    static dispatch_once_t onceToken;
    static SPTBluetoothController *_instance = nil;
    dispatch_once(&onceToken, ^{
        _instance= [[SPTBluetoothController alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        self.beanManager = [[PTDBeanManager alloc] initWithDelegate:self];
    }
    return self;
}

- (BOOL)isConnected
{
    return self.bean.state == BeanState_ConnectedAndValidated;
}

- (void)sendSerialString:(NSString *)message completion:(SPTBeanWriteCompletion)completion
{
    message = [message stringByAppendingString:@"\n"];
    
    if ( [self isConnected] ) {
        [self.bean sendSerialString:message];
        if ( completion ) {
            completion(YES, nil);
        }
        self.bean = nil;
    } else {
        self.writeCompletion = completion;
        self.serialWriteString = message;
        if ( self.beanManager.state == BeanManagerState_PoweredOn ) {
            [self connect];
        }
    }
}

- (void)writeSerialStringToBean:(NSTimer *)timer
{
    [self.bean sendSerialString:self.serialWriteString];
    if ( self.writeCompletion ) {
        self.writeCompletion(YES, nil);
        self.writeCompletion = nil;
    }
    self.serialWriteString = nil;
    self.bean = nil;
}

#pragma mark - bean methods

- (void)connect;
{
    NSError *error;
    [self.beanManager startScanningForBeans_error:&error];
    NSLog(@"");
}

- (void)disconnect;
{
    [self.beanManager disconnectBean:self.bean error:nil];
}

- (void)cancelScan
{
    [self.beanManager stopScanningForBeans_error:nil];
}

- (void)bean:(PTDBean *)bean serialDataReceived:(NSData *)data
{
    [self.beanManager disconnectBean:bean error:nil];
    self.bean = nil;
}

#pragma mark - BeanManagerDelegate Callbacks

- (void)beanManagerDidUpdateState:(PTDBeanManager *)manager
{
    if ( manager.state == BeanManagerState_PoweredOn && self.serialWriteString ) {
        [manager startScanningForBeans_error:nil];
    }
}

- (void)BeanManager:(PTDBeanManager*)beanManager didDiscoverBean:(PTDBean*)bean error:(NSError*)error
{
    if ( [bean.name isEqualToString:@"LittleBlueLCD"] ) {
        [self.beanManager connectToBean:bean error:nil];
    }
}

- (void)BeanManager:(PTDBeanManager*)beanManager didConnectToBean:(PTDBean*)bean error:(NSError*)error
{
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        if ( self.writeCompletion ) {
            self.writeCompletion(NO, error);
        }
        return;
    }
    [self.beanManager stopScanningForBeans_error:&error];
    self.bean = bean;
    self.bean.delegate = self;
    if ( self.serialWriteString ) {
        self.serialWriteDelayTimer = [NSTimer scheduledTimerWithTimeInterval:12 target:self selector:@selector(writeSerialStringToBean:) userInfo:nil repeats:NO];
    }
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
}

@end
