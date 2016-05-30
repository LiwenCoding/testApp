//
//  MedicationTableViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/22/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "MedicationTableViewController.h"
#import "AllergyTableViewController.h"
#import "MBProgressHUD.h"
#import "RKDropdownAlert.h"
#import "ReasonViewController.h"

@interface MedicationTableViewController ()
@property (strong, nonatomic) NSArray *medicationArray;
@property (strong, nonatomic) NSString *headerValue;
@end

@implementation MedicationTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"medication view load");
//    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.barStyle  = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:44.0/255.0 green:192.0/255.0 blue:83.0/255.0 alpha:1];
    NSLog(@"most updated patientInfo is %@", self.patientInfo);
    self.headerValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerValue"];
    [self getPatientHealthHistory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void) getPatientHealthHistory {
    
    NSLog(@"download medi task");
    //show progress indicator
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Loading...";
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"https://drchrono.com/api/medications?patient=%@", [self.patientInfo objectForKey:@"id"]];
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
                
                if ([count intValue] != 0) {
                    self.medicationArray = [requestReply objectForKey:@"results"];
//                    NSLog(@"medication array %@", self.medicationArray);
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.tableView reloadData];
                    NSLog(@"reload table");
                });
                
                
            }
        }] resume];
        
    });
    
    
}

- (IBAction)nextButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"showReason" sender:self];
}

//- (IBAction)finishButtonPressed:(id)sender {
//    
//    [self saveAllInfomationToServer];
//}





- (IBAction)backButtonPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"backAllergy" sender:self];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.medicationArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"medication" forIndexPath:indexPath];
    
    cell.textLabel.text = [[self.medicationArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}






#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"showReason"]) {
        ReasonViewController *vc = segue.destinationViewController;
        vc.patientInfo = self.patientInfo;
        vc.reason = self.reason;
        vc.notes = self.notes;
        vc.appointmentId = self.appointmentId;

        
    }
    
    if ([[segue identifier] isEqualToString:@"backAllergy"]) {
        AllergyTableViewController *vc = segue.destinationViewController;
        vc.patientInfo = self.patientInfo;
        vc.reason = self.reason;
        vc.notes = self.notes;
        vc.appointmentId = self.appointmentId;

        
    }
    
    
    
}

@end
