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

@interface MedicationTableViewController ()
@property (strong, nonatomic) NSArray *medicationArray;
@property (strong, nonatomic) NSString *headerValue;
@end

@implementation MedicationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
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
                });
                
                
            }
        }] resume];
        
    });
    
    
}


- (IBAction)finishButtonPressed:(id)sender {
    
    [self saveAllInfomationToServer];
}





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



- (void)saveAllInfomationToServer {

    //show progress indicator
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Saving...";

    [self.patientInfo removeObjectsForKeys:@[@"tertiary_insurance", @"patient_photo", @"patient_photo_date", @123, @3.14]];
    NSLog(@"serialized dictionary is %@", self.patientInfo);
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:self.patientInfo options:0 error:&error];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *url = [NSString stringWithFormat:@"https://drchrono.com/api/patients/%@", [self.patientInfo objectForKey:@"id"]];
    NSLog(@"url is : %@", url);
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"PATCH"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:self.headerValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:postData];
    
    dispatch_queue_t fetchQ = dispatch_queue_create("fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (data) {
                NSDictionary *requestReply = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error: &error];
                if ([requestReply objectForKey:@"id"]) {
                    //post success
                    dispatch_async(dispatch_get_main_queue(), ^{

                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [RKDropdownAlert title:@"Success" message:@"All information has been succussfully saved!" backgroundColor:[UIColor colorWithRed:44.0/255.0 green:192.0/255.0 blue:83.0/255.0 alpha:0.8] textColor:[UIColor whiteColor] time:3];
                        
                        // go to main page
                        [self performSegueWithIdentifier:@"finish" sender:self];

                        
                    });
                } else {
                    //post failure
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [RKDropdownAlert title:@"Save Failed" message:@"Please try later!" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:3];
                    });
                }
                NSLog(@"patch response is : %@", requestReply);
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



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    
    if ([[segue identifier] isEqualToString:@"backAllergy"]) {
        AllergyTableViewController *vc = segue.destinationViewController;
        vc.patientInfo = self.patientInfo;
        
    }
    
    
    
}

@end
