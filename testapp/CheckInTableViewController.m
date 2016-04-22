//
//  CheckInTableViewController.m
//  testapp
//
//  Created by Shen Liwen on 4/22/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "CheckInTableViewController.h"
#import "CheckInTableViewCell.h"

@interface CheckInTableViewController ()
@property (strong, nonatomic) NSString *headerValue;
//@property (strong, nonatomic) NSDictionary *patientInfo;
@property (strong, nonatomic) NSArray *labelArray;
@property (strong, nonatomic) NSMutableArray *textFieldArray;
@end

@implementation CheckInTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    self.headerValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerValue"];
//    self.patientInfo = [[NSDictionary alloc] init];
    self.labelArray = [NSArray arrayWithObjects:@"first_name", @"last_name", @"gender", @"date_of_birth", @"cell_phone", @"address", nil];
    self.textFieldArray = [[NSMutableArray alloc] init];
    [self requestAppointmentList];
    NSLog(@"patientid is %@", self.patientId);

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.textFieldArray.count;
//    return 10;
}
//
//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    
    CheckInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    cell.textLabel.text = @"dddd";
//    cell.label.text = @"dddd";
//    cell.textField.text = @"dddd";
//    cell.textLabel.text = [self.labelArray objectAtIndex:indexPath.row];
    cell.label.text = [self.labelArray objectAtIndex:indexPath.row];
    cell.text.text = [self.textFieldArray objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (IBAction)requestAppointmentList {
    
    
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://drchrono.com/api/patients"]];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:self.headerValue forHTTPHeaderField:@"Authorization"];
    
        dispatch_queue_t fetchQ = dispatch_queue_create("fetcher", NULL);
        dispatch_async(fetchQ, ^{
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (data) {
            NSDictionary *requestReply = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error: &error];

                NSDictionary *results = [requestReply objectForKey:@"results"];
                for (NSDictionary *everyRecord in results) {
                    NSLog(@"id is %@", [everyRecord objectForKey:@"id"]);
                    if ([everyRecord objectForKey:@"id"] == self.patientId) {
//                        self.patientInfo = everyRecord;
                        [self.textFieldArray addObject:[everyRecord objectForKey:@"first_name"]];
                        [self.textFieldArray addObject:[everyRecord objectForKey:@"last_name"]];
                        [self.textFieldArray addObject:[everyRecord objectForKey:@"gender"]];
                        [self.textFieldArray addObject:[everyRecord objectForKey:@"date_of_birth"]];
                        [self.textFieldArray addObject:[everyRecord objectForKey:@"cell_phone"]];
                        [self.textFieldArray addObject:[everyRecord objectForKey:@"address"]];
                        NSLog(@"textarray  is %@", self.textFieldArray);
                        NSLog(@"label array is %@", self.labelArray);
                        break;
                    }
                }
//                NSLog(@"diction : %@", self.patientInfo);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });

            
            
            }
        }] resume];
});

    
    
//    [self.refreshControl beginRefreshing];
//    [self.appointmentList removeAllObjects];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    NSDate *date = [NSDate date];
//    NSString *dateString = [[[date description] componentsSeparatedByString: @" "] objectAtIndex:0];
    

    
//    NSString *appointmentURLString = [NSString stringWithFormat:@"https://drchrono.com/api/appointments?date=%@", [self.patientId stringValue]];
//    [request setURL:[NSURL URLWithString:appointmentURLString]];
//    [request setHTTPMethod:@"GET"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:self.headerValue forHTTPHeaderField:@"Authorization"];
//    
//    
//    dispatch_queue_t fetchQ = dispatch_queue_create("fetcher", NULL);
//    dispatch_async(fetchQ, ^{
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//            
//            if (data) {
//                NSDictionary *requestReply = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error: &error];
//                NSDictionary *results = [requestReply objectForKey:@"results"];
//                for (NSDictionary *everyRecord in results) {
//                    
//                    NSNumber *patientId = [everyRecord objectForKey:@"patient"];
//                    NSString *date = [everyRecord objectForKey:@"scheduled_time"];
//                    NSString *reason = [everyRecord objectForKey:@"reason"];
//                    
//                    Appointment *appointment = [[Appointment alloc] initWithPatientId:patientId withDate:date withReason:reason];
//                    [self.appointmentList addObject:appointment];
//                }
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.refreshControl endRefreshing];
//                    [self.tableView reloadData];
//                });
//            }
//            
//        }] resume];
//        
//        
//    });
    
    
    
}







/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
