//
//  SPTDataController.h
//  Spatializer
//
//  Created by Zeke Shearer on 1/8/15.
//  Copyright (c) 2015 Zeke Shearer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPTDataController : NSObject

+ (SPTDataController *)instance;

- (void)fetchForecastForLocation:(NSString *)locationName completion:(void(^)(NSString *forecast, NSError *error))completion;
- (void)fetchCurrentTempForLocation:(NSString *)locationName completion:(void(^)(NSString *currentTemp, NSError *error))completion;

@end
