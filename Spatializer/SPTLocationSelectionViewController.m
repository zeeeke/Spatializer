//
//  SPTLocationSelectionViewController.m
//  Spatializer
//
//  Created by Zeke Shearer on 1/8/15.
//  Copyright (c) 2015 Zeke Shearer. All rights reserved.
//

#import "SPTLocationSelectionViewController.h"
#import "SPTDataController.h"
#import "SPTBluetoothController.h"

@interface SPTLocationSelectionViewController ()

@end

@implementation SPTLocationSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)doIt:(id)sender
{
    [[SPTDataController instance] fetchForecastForLocation:@"" completion:^(NSString *forecast, NSError *error) {
        if ( forecast ) {
            [[SPTBluetoothController instance] sendSerialString:forecast completion:^(BOOL success, NSError *error) {
                
            }];
        }
    }];
}

@end
