//
//  MasterTableViewController.m
//  testapp
//
//  Created by Shen Liwen on 4/21/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "MasterTableViewController.h"
#import "AppointmentTableViewCell.h"
#import "MBProgressHUD.h"
#import "RKDropdownAlert.h"
#import "UIImage+scale.h"

@interface MasterTableViewController ()
// atomic is for multi-threading tasks
@property (strong, atomic) NSMutableArray *appointmentArray;
@property (strong, atomic) NSMutableArray *patientArray;
@property (strong, atomic) NSMutableDictionary *patientDictionary;
@property (strong, nonatomic) NSString *headerValue;
@end

@implementation MasterTableViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.headerValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerValue"];
    //show progress indicator
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [self requestAppointmentList];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:44.0/255.0 green:192.0/255.0 blue:83.0/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.appointmentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppointmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // reason
    cell.reason.text = [[self.appointmentArray objectAtIndex:indexPath.row] objectForKey:@"reason"];
    // date
    NSArray *temp = [[[self.appointmentArray objectAtIndex:indexPath.row] objectForKey:@"scheduled_time"] componentsSeparatedByString:@"T"];
    NSArray *temp2 = [[temp objectAtIndex:1] componentsSeparatedByString:@":"];
    NSString *date = [NSString stringWithFormat:@"%@:%@",[temp2 objectAtIndex:0],[temp2 objectAtIndex:1]];
    cell.date.text = date;
    // exam
    cell.exam.text = [NSString stringWithFormat:@"Exam %@",[[[self.appointmentArray objectAtIndex:indexPath.row] objectForKey:@"exam_room"] stringValue]];
    //status
    if ([[[self.appointmentArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqual:[NSNull null]]) {
        cell.status.text = @"";
    } else {
        cell.status.text = [[self.appointmentArray objectAtIndex:indexPath.row] objectForKey:@"status"];
    }
    // name
    cell.name.text = [NSString stringWithFormat:@"%@ %@",[[self.patientArray objectAtIndex:indexPath.row] objectForKey:@"first_name"],[[self.patientArray objectAtIndex:indexPath.row] objectForKey:@"last_name"]];
    
    // if there is an image
    cell.imageView.layer.cornerRadius = 5.0;
    cell.imageView.layer.masksToBounds = YES;
    if(![[[self.patientArray objectAtIndex:indexPath.row] objectForKey:@"patient_photo"] isEqual:[NSNull null]]) {
        NSURL *imageURL = [NSURL URLWithString:[[self.patientArray objectAtIndex:indexPath.row]objectForKey:@"patient_photo"]];
        UIImage *image = [[UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]] scaleToSize:CGSizeMake(80.0f, 80.0f)];
        cell.imageView.image = image;
    }
    return cell;
}

#pragma mark - request data

- (IBAction)requestAppointmentList {
    
    [self.refreshControl beginRefreshing];
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
                self.appointmentArray = [NSMutableArray arrayWithArray:[requestReply objectForKey:@"results"]];
                self.patientArray = [[NSMutableArray alloc] init];
                self.patientDictionary = [[NSMutableDictionary alloc] init];
//                NSLog(@"appointArray is %@", self.appointmentArray);
                [self getPatientArray];
            }
        }] resume];
    });
}

- (IBAction)calendarButtonPressed:(id)sender {
    [RKDropdownAlert title:@"Hodor" message:@"Comming soon!" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:3];
    return;
}

- (void)getPatientArray {
    __block int count = 0;
    for (NSDictionary *everyRecord in self.appointmentArray) {
        NSString *patientId = [everyRecord objectForKey:@"patient"];
        // request every patientInfo and put in patientArray
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSString *urlString = [NSString stringWithFormat:@"https://drchrono.com/api/patients/%@", patientId];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:self.headerValue forHTTPHeaderField:@"Authorization"];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (data) {
                NSDictionary *singlePatientInfoDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
                [self.patientDictionary setObject:singlePatientInfoDictionary forKey:patientId];
                count ++;
//                NSLog(@"count is %d", count);
                if (count == [self.appointmentArray count]) {
                    [self orderArray];
//                    NSLog(@"patientArray array is %@", self.patientArray);
                }
            }
        }] resume];
    }
}

// put patientInfo into patientArray in order
- (void) orderArray {

    for (NSDictionary *everyAppointment in self.appointmentArray) {
        NSString *patientId = [everyAppointment objectForKey:@"patient"];
//        NSLog(@"order array patient id is %@", patientId);
        [self.patientArray addObject:[self.patientDictionary objectForKey:patientId]];
    }
//    NSLog(@"order array is %@", self.patientArray);
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    });
}

@end
