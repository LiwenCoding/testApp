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
    
//    NSString *doctor = @"89784";
    
//    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys: [self.patientInfo objectForKey:@"first_name"], @"first_name", [self.patientInfo objectForKey:@"last_name"], @"last_name", [self.patientInfo objectForKey:@"cell_phone"], @"cell_phone", [self.patientInfo objectForKey:@"gender"], @"gender", doctor, @"doctor", [self.patientInfo objectForKey:@"data_of_birth"], @"date_of_birth", [self.patientInfo objectForKey:@"address"], @"address", [self.patientInfo objectForKey:@"city"], @"city", [self.patientInfo objectForKey:@"email"], @"email",[self.patientInfo objectForKey:@"emergency_contact_name"], @"emergency_contact_name",[self.patientInfo objectForKey:@"emergency_contact_phone"], @"emergency_contact_phone",[self.patientInfo objectForKey:@"emergency_contact_relation"], @"emergency_contact_relation",[self.patientInfo objectForKey:@"ethnicity"], @"ethnicity", [self.patientInfo objectForKey:@"home_phone"], @"home_phone",[self.patientInfo objectForKey:@"middle_name"], @"middle_name",[self.patientInfo objectForKey:@"office_phone"], @"office_phone",[self.patientInfo objectForKey:@"preferred_language"], @"preferred_language",[self.patientInfo objectForKey:@"race"], @"race",[self.patientInfo objectForKey:@"social_security_number"], @"social_security_number",[self.patientInfo objectForKey:@"state"], @"state",[self.patientInfo objectForKey:@"zip_code"], @"zip_code",[self.patientInfo objectForKey:@"ethnicity"], @"ethnicity",[self.patientInfo objectForKey:@"primary_insurance"], @"primary_insurance",[self.patientInfo objectForKey:@"secondary_insurance"], @"secondary_insurance",
//                         nil];
    
//    
//    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys: [self.textFieldArray objectAtIndex:0], @"first_name", [self.textFieldArray objectAtIndex:1], @"last_name", [self.textFieldArray objectAtIndex:4], @"cell_phone", [self.textFieldArray objectAtIndex:2], @"gender", doctor, @"doctor", [self.textFieldArray objectAtIndex:3], @"date_of_birth", [self.textFieldArray objectAtIndex:2], @"address",
//                         nil];
    
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
                        [RKDropdownAlert title:@"good" message:@"good!" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:3];
                    });
                } else {
                    //post failure
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [RKDropdownAlert title:@"Save Failed" message:@"Please try later!" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:3];
                    });
                }
                NSLog(@"patch response is : %@", requestReply);
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
