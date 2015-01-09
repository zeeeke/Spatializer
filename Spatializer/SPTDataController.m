//
//  SPTDataController.m
//  Spatializer
//
//  Created by Zeke Shearer on 1/8/15.
//  Copyright (c) 2015 Zeke Shearer. All rights reserved.
//

#import "SPTDataController.h"
#import "AFNetworking.h"

static NSString *SPTWeatherUrlString = @"http://api.wunderground.com/api/8f04beed366a639c/%@/q/CA/San_Francisco.json";

@implementation SPTDataController

+ (SPTDataController *)instance
{
    static dispatch_once_t onceToken;
    static SPTDataController *_instance = nil;
    dispatch_once(&onceToken, ^{
        _instance= [[SPTDataController alloc] init];
    });
    return _instance;
}

- (void)fetchForecastForLocation:(NSString *)locationName completion:(void(^)(NSString *forecast, NSError *error))completion
{
    AFHTTPRequestOperationManager *manager;
    
    manager = [[AFHTTPRequestOperationManager alloc] init];
    
    [manager GET:[self weatherUrlForServiceName:@"forecast"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *forecastDictionary;
        NSArray *textArray;
        NSDictionary *forecastPeriod;
        NSString *forecastText;
        
        forecastDictionary = [responseObject objectForKey:@"forecast"];
        textArray = [forecastDictionary valueForKeyPath:@"txt_forecast.forecastday"];
        forecastPeriod = [textArray firstObject];
        forecastText = [forecastPeriod objectForKey:@"fcttext"];
        if ( forecastText.length ) {
            completion(forecastText, nil);
        } else {
            completion(nil, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)fetchCurrentTempForLocation:(NSString *)locationName completion:(void(^)(NSString *currentTemp, NSError *error))completion
{
    
}

- (NSString *)weatherUrlForServiceName:(NSString *)serviceName;
{
    return [NSString stringWithFormat:SPTWeatherUrlString, serviceName ];
}

@end
