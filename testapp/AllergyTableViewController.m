//
//  AllergyTableViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/22/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "AllergyTableViewController.h"
#import "MedicationTableViewController.h"
#import "SecondaryInsuranceViewController.h"
#import "AllergyTableViewCell.h"
#import "MBProgressHUD.h"
#import "RKDropdownAlert.h"

@interface AllergyTableViewController ()
@property (strong, nonatomic) NSString *headerValue;
@property (strong, nonatomic) NSArray *allergyArray;

@end

@implementation AllergyTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle  = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:44.0/255.0 green:192.0/255.0 blue:83.0/255.0 alpha:1];
    self.headerValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerValue"];
    [self getPatientHealthHistory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) getPatientHealthHistory {
    // show progress indicator
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Loading...";
    // generate request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"https://drchrono.com/api/allergies?verbose=true&patient=%@", [self.patientInfo objectForKey:@"id"]];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:self.headerValue forHTTPHeaderField:@"Authorization"];
    dispatch_queue_t fetchQ = dispatch_queue_create("fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (data) {
                NSDictionary *requestReply = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
//                NSLog(@"request reply for history is %@", requestReply);
                NSNumber *count = [requestReply objectForKey:@"count"];
//                NSLog(@"count is %@", count);
                if ([count intValue] != 0) {
                    self.allergyArray = [requestReply objectForKey:@"results"];
//                    NSLog(@"allergy array %@", self.allergyArray);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.tableView reloadData];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [RKDropdownAlert title:@"Error" message:@"No internet connection, please try later!" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:3];
                    return;
                });
            }
        }] resume];
    });
}

- (IBAction)backButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"backSecondaryInsurance" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allergyArray count];
}

- (AllergyTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AllergyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allergy" forIndexPath:indexPath];
    cell.allergyDescription.text = [[self.allergyArray objectAtIndex:indexPath.row] objectForKey:@"description"];
    cell.reaction.text = [[self.allergyArray objectAtIndex:indexPath.row] objectForKey:@"reaction"];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showMedication"]) {
        UINavigationController *navi = segue.destinationViewController;
        MedicationTableViewController *vc = (MedicationTableViewController *)navi.topViewController;
        vc.patientInfo = self.patientInfo;
        vc.reason = self.reason;
        vc.notes = self.notes;
        vc.appointmentId = self.appointmentId;
    }
    if ([[segue identifier] isEqualToString:@"backSecondaryInsurance"]) {
        SecondaryInsuranceViewController *vc = segue.destinationViewController;
        vc.patientInfo = self.patientInfo;
        vc.reason = self.reason;
        vc.notes = self.notes;
        vc.appointmentId = self.appointmentId;
    }
}

@end
