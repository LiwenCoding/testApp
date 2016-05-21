//
//  MasterTableViewController.m
//  testapp
//
//  Created by Shen Liwen on 4/21/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "MasterTableViewController.h"
#import "DetailViewController.h"
#import "Appointment.h"

@interface MasterTableViewController ()
@property (strong, nonatomic) NSMutableArray *appointmentList;
@property (strong, nonatomic) NSString *headerValue;
@end

@implementation MasterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerValue"];
    self.appointmentList = [[NSMutableArray alloc] init];
    [self requestAppointmentList];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
            DetailViewController *detailViewController = segue.destinationViewController;
            Appointment *appointment = [self.appointmentList objectAtIndex:indexPath.row];
            detailViewController.patientId = appointment.patientId;
    }
}


#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.appointmentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Appointment *appointment = [self.appointmentList objectAtIndex:indexPath.row];
    cell.textLabel.text = appointment.date;
    return cell;
}

#pragma mark - request data

- (IBAction)requestAppointmentList {
    
    [self.refreshControl beginRefreshing];
    [self.appointmentList removeAllObjects];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    NSDate *date = [NSDate date];
//    NSString *dateString = [[[date description] componentsSeparatedByString: @" "] objectAtIndex:0];
    // appointments on 4-23
    NSString *dateString = @"2016-04-23";
    NSString *appointmentURLString = [NSString stringWithFormat:@"https://drchrono.com/api/appointments?date=%@", dateString];
    [request setURL:[NSURL URLWithString:appointmentURLString]];
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
                    NSNumber *patientId = [everyRecord objectForKey:@"patient"];
                    NSString *date = [everyRecord objectForKey:@"scheduled_time"];
                    NSString *reason = [everyRecord objectForKey:@"reason"];
                    Appointment *appointment = [[Appointment alloc] initWithPatientId:patientId withDate:date withReason:reason];
                    [self.appointmentList addObject:appointment];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.refreshControl endRefreshing];
                    [self.tableView reloadData];
                });
            }
        }] resume];
    });
}
@end
