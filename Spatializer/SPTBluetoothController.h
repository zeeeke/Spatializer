//
//  SPTBluetoothController.h
//  Spatializer
//
//  Created by Zeke Shearer on 1/8/15.
//  Copyright (c) 2015 Zeke Shearer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SPTBeanWriteCompletion) (BOOL success, NSError *error);

@interface SPTBluetoothController : NSObject

+ (SPTBluetoothController *)instance;

- (void)sendSerialString:(NSString *)message completion:(SPTBeanWriteCompletion)completion;

@end
