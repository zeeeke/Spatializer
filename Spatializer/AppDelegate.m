//
//  AppDelegate.m
//  Spatializer
//
//  Created by Zeke Shearer on 1/8/15.
//  Copyright (c) 2015 Zeke Shearer. All rights reserved.
//

#import "AppDelegate.h"
#import "SPTLocationSelectionViewController.h"
#import "SPTBluetoothController.h"
#import "SPTDataController.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    SPTLocationSelectionViewController *locationSelectionViewController;
    UINavigationController *navigationController;
    
    //parse and push stuff
    [Parse setApplicationId:@"SwNSqR9uP2AnjUe8J8dDCzyZpmwVr0Um5eoJq9Bd" clientKey:@"dvJ1Hvse9GrJo1Zpr9RmhVCeUq0WEnjYpD03UxoF"];
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    locationSelectionViewController = [[SPTLocationSelectionViewController alloc] initWithNibName:@"SPTLocationSelectionViewController" bundle:nil];
    navigationController = [[UINavigationController alloc] initWithRootViewController:locationSelectionViewController];
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[SPTDataController instance] fetchForecastForLocation:@"" completion:^(NSString *forecast, NSError *error) {
        if ( forecast ) {
            [[SPTBluetoothController instance] sendSerialString:forecast completion:^(BOOL success, NSError *error) {
                
            }];
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[SPTDataController instance] fetchForecastForLocation:@"" completion:^(NSString *forecast, NSError *error) {
        if ( forecast ) {
            [[SPTBluetoothController instance] sendSerialString:forecast completion:^(BOOL success, NSError *error) {
                if ( completionHandler ) {
                    if ( success ) {
                        completionHandler(UIBackgroundFetchResultNewData);
                    } else {
                        completionHandler(UIBackgroundFetchResultFailed);
                    }
                }
            }];
        } else {
            if ( completionHandler ) {
                completionHandler(UIBackgroundFetchResultFailed);
            }
        }
    }];
}

@end
