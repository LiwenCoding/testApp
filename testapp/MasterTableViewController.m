//
//  MasterTableViewController.m
//  testapp
//
//  Created by Shen Liwen on 4/21/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "MasterTableViewController.h"
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

    return [self.appointmentList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Appointment *appointment = [self.appointmentList objectAtIndex:indexPath.row];
    cell.textLabel.text = appointment.date;
    return cell;
}


- (void)requestAppointmentList {
    
    
    

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSDate *date = [NSDate date];
    NSString *dateString = [[[date description] componentsSeparatedByString: @" "] objectAtIndex:0];
    NSLog(@"date is : %@", dateString);
    NSString *appointmentURLString = [NSString stringWithFormat:@"https://drchrono.com/api/appointments?date=%@", dateString];
    NSLog(@"url is : %@", appointmentURLString);
    
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
            
//                NSLog(@"result is : %@ , %@ , %@", patientId, date, reason);
                
                Appointment *appointment = [[Appointment alloc] initWithPatientId:patientId withDate:date withReason:reason];
                [self.appointmentList addObject:appointment];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
//            NSLog(@"count is : %lu", (unsigned long)self.appointmentList.count);
        }
        
        
        
        
    }] resume];
    

    });



}






//- (void)searchImage:(NSString *)searchBarText {
//    
//    if ([[self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 || ![self.searchBar.text canBeConvertedToEncoding:NSASCIIStringEncoding]) {
//        [self alert:@"Please input valid words"];
//        return;
//    }
//    [self.imageObjectArray removeAllObjects];
//    [self.spinner setHidden:NO];
//    [self.spinner startAnimating];
//    NSString *urlString = [NSString stringWithFormat: @"https://www.googleapis.com/customsearch/v1?key=AIzaSyBRg5LK-KbrMl_0P3TCuo6zCWzAc8DxsKA&fields=items(link,image)&cx=016158573882785274321:ggdz0pbb7va&q=%@&searchType=image", [searchBarText stringByReplacingOccurrencesOfString:@" " withString:@""]];
//    dispatch_queue_t fetchQ = dispatch_queue_create("goolge api fetcher", NULL);
//    dispatch_async(fetchQ, ^{
//        NSError *error;
//        NSData *Rawdata = [NSData dataWithContentsOfURL: [NSURL URLWithString:urlString]];
//        if (Rawdata) {
//            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:Rawdata options:kNilOptions error: &error];
//            if (!error) {
//                NSArray *items = [jsonData valueForKey:@"items"];
//                for (NSDictionary *everyImage in items) {
//                    NSURL *thumbnailURL = [NSURL URLWithString:[[everyImage valueForKey:@"image"] valueForKey:@"thumbnailLink"]];
//                    NSData *thumbnailImageData = [NSData dataWithContentsOfURL:thumbnailURL];
//                    NSURL *imageURL = [NSURL URLWithString:[everyImage valueForKey:@"link"]];
//                    CGFloat height = (int)[[everyImage valueForKey:@"image"] valueForKey:@"thumbnailHeight"];
//                    CGFloat width = (int)[[everyImage valueForKey:@"image"] valueForKey:@"thumbnailWidth"];
//                    CGSize thumbnailSize = CGSizeMake(width, height);
//                    ImageObject *imageObject = [[ImageObject alloc]initWithImageURL:imageURL withThumbnailImageData:thumbnailImageData withThumbnailSize:thumbnailSize];
//                    [self.imageObjectArray addObject:imageObject];
//                }
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.spinner stopAnimating];
//                    [self.spinner setHidden:YES];
//                    [self.collectionView reloadData];
//                });
//            } else {
//                NSLog(@"error!");
//            }
//        } else {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self alert:@"Cannot connect to Internet!"];
//                [self.spinner stopAnimating];
//                [self.spinner setHidden:YES];
//                [self.collectionView reloadData];
//                return;
//            });
//        }
//    });
//}












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
