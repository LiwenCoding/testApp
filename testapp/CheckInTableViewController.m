//
//  CheckInTableViewController.m
//  testapp
//
//  Created by Shen Liwen on 4/22/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "CheckInTableViewController.h"
#import "CheckInTableViewCell.h"

@interface CheckInTableViewController () <UITextFieldDelegate>
@property (strong, nonatomic) NSString *headerValue;
@property (strong, nonatomic) NSArray *labelArray;
@property (strong, nonatomic) NSMutableArray *textFieldArray;
@end

@implementation CheckInTableViewController
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

    
}
- (IBAction)save:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    for (int i = 0; i < 6; i++) {
        CheckInTableViewCell *cell = (id)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UITextField *cellTextField = cell.text;
        NSString *info = cellTextField.text;
        [self.textFieldArray replaceObjectAtIndex:i withObject:info];
    }
    [self savePatientInfo];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerValue"];
    self.labelArray = [NSArray arrayWithObjects:@"first_name", @"last_name", @"gender", @"date_of_birth", @"cell_phone", @"address", nil];
    self.textFieldArray = [[NSMutableArray alloc] init];
    [self requestPatientInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.textFieldArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CheckInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.label.text = [self.labelArray objectAtIndex:indexPath.row];
    cell.text.text = [self.textFieldArray objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - request and handle data

- (void)requestPatientInfo {
    
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
                    if ([everyRecord objectForKey:@"id"] == self.patientId) {
                        [self.textFieldArray addObject:[everyRecord objectForKey:@"first_name"]];
                        [self.textFieldArray addObject:[everyRecord objectForKey:@"last_name"]];
                        [self.textFieldArray addObject:[everyRecord objectForKey:@"gender"]];
                        [self.textFieldArray addObject:[everyRecord objectForKey:@"date_of_birth"]];
                        [self.textFieldArray addObject:[everyRecord objectForKey:@"cell_phone"]];
                        [self.textFieldArray addObject:[everyRecord objectForKey:@"address"]];
                        break;
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }] resume];
    });
}


- (void) savePatientInfo {

    NSString *doctor = @"89784";
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys: [self.textFieldArray objectAtIndex:0], @"first_name", [self.textFieldArray objectAtIndex:1], @"last_name", [self.textFieldArray objectAtIndex:4], @"cell_phone", [self.textFieldArray objectAtIndex:2], @"gender", doctor, @"doctor", [self.textFieldArray objectAtIndex:3], @"date_of_birth", [self.textFieldArray objectAtIndex:2], @"address",
                         nil];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *url = [NSString stringWithFormat:@"https://drchrono.com/api/patients/%@", self.patientId];
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
                        [self alert:@"Success!"];
                    });
                } else {
                    //post failure
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self alert:@"failure, please try again"];
                    });
                }
                NSLog(@"requestReply: %@", requestReply);
                NSLog(@"id is : %@", self.patientId);
                NSLog(@"access_token is %@", self.headerValue);
            }
        }] resume];
    });
}


#pragma mark - alert

- (void)alert:(NSString *)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Information" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
