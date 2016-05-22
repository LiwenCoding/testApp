//
//  MatchUserViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/16/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "MatchUserViewController.h"
#import "MBProgressHUD.h"
#import "RKDropdownAlert.h"
#import "PhotoViewController.h"

@interface MatchUserViewController () <UITextFieldDelegate>
@property (strong, nonatomic) NSString *headerValue;
@property (strong, nonatomic) NSMutableDictionary *patientInfo;
@end

@implementation MatchUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerValue"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)editDidBegin:(id)sender {
    if (self.dateOfBirth.inputView == nil) {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(updateTextField:)
             forControlEvents:UIControlEventValueChanged];
        [self.dateOfBirth setInputView:datePicker];
        UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        [toolBar setTintColor:[UIColor grayColor]];
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed)];
        UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
        [self.dateOfBirth setInputAccessoryView:toolBar];
    }
}

- (IBAction)enterButtonPressed:(id)sender {
    [self.view endEditing:YES];
    //validate input
    if ([[self.firstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 || ![self.firstName.text canBeConvertedToEncoding:NSASCIIStringEncoding] || [[self.lastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 || ![self.lastName.text canBeConvertedToEncoding:NSASCIIStringEncoding] || [[self.dateOfBirth.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 || ![self.dateOfBirth.text canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        //drop down alert
        [RKDropdownAlert title:@"Login Failed" message:@"Please input valid information" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:3];
        return;
    }
    //show progress indicator
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Verifying...";
    // match patient record
    [self getPatientInfo];
}

-(void)updateTextField:(UIDatePicker *)sender {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        self.dateOfBirth.text = [formatter stringFromDate:sender.date];
}

-(void)doneButtonPressed {
    [self.dateOfBirth resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)getPatientInfo {
    //generate request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"https://drchrono.com/api/patients?verbose=true&last_name=%@&first_name=%@&date_of_birth=%@", self.lastName.text, self.firstName.text, self.dateOfBirth.text];
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
                //if there is no patient matched
                NSLog(@"request reply is %@", requestReply);
                NSNumber *count = [requestReply objectForKey:@"count"];
                NSLog(@"count is %@", count);
                if ([count intValue] == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [RKDropdownAlert title:@"Login Failed" message:@"No matched record found!" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:3];
                        return;
                    });
                } else {
                    //find the patient in the appointment list
                    NSMutableDictionary *resultDictionary = [[requestReply objectForKey:@"results"] objectAtIndex:0];
                    self.patientInfo = [[NSMutableDictionary alloc]initWithDictionary:resultDictionary];
                    NSLog(@"patient info: %@", self.patientInfo);
                    [self getAppointmentList];
                }
            }
        }] resume];
    });
}


- (void)getAppointmentList {
    
    NSNumber *patientIdTobeMatched = [self.patientInfo objectForKey:@"id"];
    NSLog(@"patientIdTobeMatched is %@", patientIdTobeMatched);
    if (patientIdTobeMatched) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        //    NSDate *date = [NSDate date];
        //    NSString *dateString = [[[date description] componentsSeparatedByString: @" "] objectAtIndex:0];
        // for convience, just use the appointments on 2016-04-23
        NSString *dateString = @"2016-04-23";
        NSString *appointmentURLString = [NSString stringWithFormat:@"https://drchrono.com/api/appointments?date=%@", dateString];
        [request setURL:[NSURL URLWithString:appointmentURLString]];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:self.headerValue forHTTPHeaderField:@"Authorization"];
            
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        __block int flag = 0;
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (data) {
                NSDictionary *requestReply = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error: &error];
                NSDictionary *results = [requestReply objectForKey:@"results"];
                for (NSDictionary *everyRecord in results) {
                    NSNumber *patientId = [everyRecord objectForKey:@"patient"];
                    NSLog(@"patientId every is %@", patientId);
                    BOOL compare = [patientIdTobeMatched isEqualToNumber:patientId];
                    NSLog(@"compare %d", compare);
                    if (compare) {
                        flag = 1;
                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [MBProgressHUD hideHUDForView:self.view animated:YES];
//                            [RKDropdownAlert title:@"Success!" message:@"congratulations!" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:3];
                            [self performSegueWithIdentifier:@"profilePhoto" sender:self];
                        });
                    }
                }
                if (flag == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [RKDropdownAlert title:@"Login Failed" message:@"No appointment found, please make an appointment with the doctor first." backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:3];
                        return;
                    });
                }
            }
        }] resume];
    }
}








#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"profilePhoto"]) {
        UINavigationController *navi = segue.destinationViewController;
        PhotoViewController *photoViewController = (PhotoViewController *)navi.topViewController;
        photoViewController.patientInfo = self.patientInfo;
    }
}


@end
