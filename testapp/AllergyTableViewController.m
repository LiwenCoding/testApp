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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerValue"];
    [self getPatientHealthHistory];


    // Uncomment the following line to preserve selection between presentations.
//     self.clearsSelectionOnViewWillAppear = NO;
    

    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getPatientHealthHistory {
    
    //show progress indicator
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Loading...";
    
    
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
                NSLog(@"request reply for history is %@", requestReply);
                
                NSNumber *count = [requestReply objectForKey:@"count"];
                NSLog(@"count is %@", count);
                
                
                if ([count intValue] != 0) {
                    self.allergyArray = [requestReply objectForKey:@"results"];
                    NSLog(@"allergy array %@", self.allergyArray);
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showMedication"]) {
        UINavigationController *navi = segue.destinationViewController;
        MedicationTableViewController *vc = (MedicationTableViewController *)navi.topViewController;
        vc.patientInfo = self.patientInfo;
    }
    
    if ([[segue identifier] isEqualToString:@"backSecondaryInsurance"]) {
            SecondaryInsuranceViewController *vc = segue.destinationViewController;
            vc.patientInfo = self.patientInfo;
        
    }
    
    
}
@end
