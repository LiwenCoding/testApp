//
//  MasterTableViewController.m
//  testapp
//
//  Created by Shen Liwen on 4/21/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "MasterTableViewController.h"
#import "AppointmentTableViewCell.h"

@interface MasterTableViewController ()
@property (strong, atomic) NSMutableArray *appointmentArray;
@property (strong, atomic) NSMutableArray *patientArray;
@property (strong, atomic) NSMutableDictionary *patientDictionary;
@property (strong, atomic) NSNumber *count;
@property (strong, nonatomic) NSString *headerValue;
@end

@implementation MasterTableViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.count = [NSNumber numberWithInt:0];
    self.headerValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerValue"];
    self.patientArray = [[NSMutableArray alloc] init];
    self.patientDictionary = [[NSMutableDictionary alloc] init];
    [self requestAppointmentList];

    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.barStyle  = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:44.0/255.0 green:192.0/255.0 blue:83.0/255.0 alpha:1];
//    self.appointmentList = [[NSMutableArray alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(self.view.bounds.size.width, 62.0f);
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
    cell.date.text = [[self.appointmentArray objectAtIndex:indexPath.row] objectForKey:@"scheduled_time"];
    // exam
    cell.exam.text = [[[self.appointmentArray objectAtIndex:indexPath.row] objectForKey:@"exam_room"] stringValue];
    //status
    if ([[[self.appointmentArray objectAtIndex:indexPath.row] objectForKey:@"status"] isEqual:[NSNull null]]) {
        cell.status.text = @"";
    } else {
        cell.status.text = [[self.appointmentArray objectAtIndex:indexPath.row] objectForKey:@"status"];
    }
    
//    
//    NSString *key = [[self.appointmentArray objectAtIndex:indexPath.row] objectForKey:@"patient"];
//    NSDictionary *temp = [self.patientDictionary objectForKey:key];
    
    // name
//    [self.patientDictionary objectForKey:[[self.appointmentArray objectAtIndex:indexPath.row] objectForKey:@"patient"]
    
    
    cell.name.text = [[self.patientArray objectAtIndex:indexPath.row] objectForKey:@"last_name"];
//
//    // image
//    
    if(![[[self.patientArray objectAtIndex:indexPath.row] objectForKey:@"patient_photo"] isEqual:[NSNull null]]) {
        
        NSURL *imageURL = [NSURL URLWithString:[[self.patientArray objectAtIndex:indexPath.row]objectForKey:@"patient_photo"]];
        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    
//        UIImage *image = [self startDownloadingImage:imageURL];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            cell.imageView.image = image;
//            [self.tableView reloadData];
//        });
    
    }
    
    return cell;
    
    
}

#pragma mark - request data

- (IBAction)requestAppointmentList {
    
    [self.refreshControl beginRefreshing];
//    [self.appointmentArray removeAllObjects];
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
//                NSLog(@"request appointment is %@", requestReply);
                self.appointmentArray = [NSMutableArray arrayWithArray:[requestReply objectForKey:@"results"]];
//                self.patientArray = [[NSMutableArray alloc] init];
                NSLog(@"appointArray is %@", self.appointmentArray);

                
                
                [self getPatientArray];
//                [self orderArray];
                
            }
        }] resume];
    });
}



- (void)getPatientArray {
    
    
    
    __block int count = 0;
    for (NSDictionary *everyRecord in self.appointmentArray) {
        NSString *patientId = [everyRecord objectForKey:@"patient"];
//        NSUInteger i = 9;
//        [self requestEveryPatientInfo:patientId with:i];
//        NSLog(@"patientId is %@, index is %lu ", patientId, (unsigned long)i);
//        i ++;

        
        
//        NSLog(@"really do id is %@", patientId);
        // request every patientInfo and put in patientArray
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSString *urlString = [NSString stringWithFormat:@"https://drchrono.com/api/patients/%@", patientId];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:self.headerValue forHTTPHeaderField:@"Authorization"];
        //    dispatch_queue_t fetchQ = dispatch_queue_create("fetcher", NULL);
        //    dispatch_async(fetchQ, ^{
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (data) {
                NSDictionary *singlePatientInfoDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
                //                NSLog(@"request reply is %@", singlePatientInfoDictionary);
//                NSLog(@"orderedindex is %lu", orderedIndex);
                //                [self.patientArray insertObject: singlePatientInfoDictionary atIndex:orderedIndex];
//                [self.patientArray addObject:singlePatientInfoDictionary];
//                NSLog(@"patientArray is %@", self.patientArray);
                
                
                [self.patientDictionary setObject:singlePatientInfoDictionary forKey:patientId];
                
                
                
//                
//                int temp = [self.count intValue] + 1;
////                NSLog(@"temp int is %d", temp);
//                self.count = [NSNumber numberWithInt:temp];
//                NSLog(@"count is %@", self.count);
                count ++;
                NSLog(@"count is %d", count);
                if (count == [self.appointmentArray count]) {
//                    self.count 
                    [self orderArray];
                    NSLog(@"order array is %@", self.patientArray);
                
                }
//                NSLog(@"dicitonary is %@ , the key is %@ , count is %lu", self.patientDictionary, patientId, (unsigned long)[self.patientDictionary count]);
                
//                if ([self.patientDictionary count] == 6) {
//
//                    NSLog(@"download finished!");
//                    [self orderArray];
//                    NSLog(@"ordered array is %@", self.patientArray);
//
//                    
//                    for ()
//                    NSString *key = [[self.appointmentArray objectAtIndex:indexPath.row] objectForKey:@"patient"];
//                    NSDictionary *temp = [self.patientDictionary objectForKey:key];
                
                    
                    
                    
//                    NSArray *sorted = [self.patientArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//                        if ([[obj1 objectForKey:@"scheduled_time"] earlierDate:[obj2 objectForKey:@"scheduled_time"]]) return NSOrderedAscending;
//                        else return NSOrderedDescending;
//                    }];
//                    
//                    NSLog(@"sorted array is %@", sorted);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.refreshControl endRefreshing];
//                        [self.tableView reloadData];
//                    });
//                }
            }
        }] resume];

        
        
    }
//    
//    NSLog(@"dicitonary is %@ , count is %lu", self.patientDictionary,  (unsigned long)[self.patientDictionary count]);
    
}

//
- (void) orderArray {

    for (NSDictionary *everyAppointment in self.appointmentArray) {
        NSString *patientId = [everyAppointment objectForKey:@"patient"];
        NSLog(@"order array patient id is %@", patientId);
        [self.patientArray addObject:[self.patientDictionary objectForKey:patientId]];
        
    }

    NSLog(@"order array is %@", self.patientArray);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    });


}

//- (void)requestEveryPatientInfo:(NSString *)patientId with:(NSUInteger)orderedIndex {
//    NSLog(@"really do id is %@", patientId);
//    // request every patientInfo and put in patientArray
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    NSString *urlString = [NSString stringWithFormat:@"https://drchrono.com/api/patients/%@", patientId];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"GET"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:self.headerValue forHTTPHeaderField:@"Authorization"];
////    dispatch_queue_t fetchQ = dispatch_queue_create("fetcher", NULL);
////    dispatch_async(fetchQ, ^{
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//            if (data) {
//                NSDictionary *singlePatientInfoDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
////                NSLog(@"request reply is %@", singlePatientInfoDictionary);
//                NSLog(@"orderedindex is %lu", orderedIndex);
////                [self.patientArray insertObject: singlePatientInfoDictionary atIndex:orderedIndex];
//                [self.patientArray addObject:singlePatientInfoDictionary];
//                NSLog(@"patientArray is %@", self.patientArray);
//                if ([self.patientArray count] == [self.appointmentArray count]) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.refreshControl endRefreshing];
//                        [self.tableView reloadData];
//                    });
//                }
//            }
//        }] resume];
////    });
//}

//- (UIImage *)startDownloadingImage:(NSURL *)imageURL {
//    
//                    //show progress indicator
//            //            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            //            hud.mode = MBProgressHUDModeIndeterminate;
//            //            hud.label.text = @"Loading...";
//        __block UIImage *image;
//            NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
//            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
//            
////            dispatch_queue_t fetchQ = dispatch_queue_create("fetcher", NULL);
////            dispatch_async(fetchQ, ^{
//                NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
//                NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
//                    if (!error) {
//                            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
////                            dispatch_async(dispatch_get_main_queue(), ^{
////                                //                                [MBProgressHUD hideHUDForView:self.view animated:YES];
////                                self.imageView.image = image;
////                            });
//                    }
//                }];
//                [task resume];
////            });
//    
//    return image;
//}


@end
