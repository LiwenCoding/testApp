//
//  DetailViewController.m
//  testapp
//
//  Created by Shen Liwen on 4/22/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "DetailViewController.h"
#import "CheckInTableViewController.h"

@interface DetailViewController ()
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"onboarding"]) {
        UINavigationController *navi = segue.destinationViewController;
        CheckInTableViewController *checkInController = (CheckInTableViewController *)navi.topViewController;
        checkInController.patientId = self.patientId;
    }
}

@end
