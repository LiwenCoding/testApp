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
@property (weak, nonatomic) IBOutlet UILabel *labelText;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"patientid is %@", self.patientId);
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
