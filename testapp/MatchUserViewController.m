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
#import "UIFloatLabelTextField.h"

@interface MatchUserViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *firstName;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *lastName;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *dateOfBirth;
@property (weak, nonatomic) IBOutlet UIButton *enter;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (strong, nonatomic) NSString *headerValue;
@property (strong, nonatomic) NSString *appointmentId;
@property (strong, nonatomic) NSMutableString *reason;
@property (strong, nonatomic) NSMutableString *notes;
@property (strong, nonatomic) NSMutableDictionary *patientInfo;
@end

@implementation MatchUserViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.headerValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerValue"];
    self.reason = [[NSMutableString alloc] init];
    self.notes = [[NSMutableString alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateOfBirth.delegate = self;
    [self setTextFieldUI];
    self.enter.layer.cornerRadius = 5;
    self.back.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)editDidBegin {
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

- (BOOL)textFieldShouldBeginEditing:(UIFloatLabelTextField *) textField {
    if (textField == self.dateOfBirth) {
        [self editDidBegin];
    }
    return YES;
}

- (void)setTextFieldUI {
    [self.dateOfBirth setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.dateOfBirth.floatLabelActiveColor = [UIColor orangeColor];
    self.dateOfBirth.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    [self.firstName setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.firstName.floatLabelActiveColor = [UIColor orangeColor];
    self.firstName.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    [self.lastName setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.lastName.floatLabelActiveColor = [UIColor orangeColor];
    self.lastName.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    // set bottom border
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.dateOfBirth.frame.size.height - 1, self.dateOfBirth.frame.size.width - 1, 1.0f);
    bottomBorder.backgroundColor = [UIColor grayColor].CGColor;
    
    CALayer *bottomBorder2 = [CALayer layer];
    bottomBorder2.frame = CGRectMake(0.0f, self.firstName.frame.size.height - 1, self.firstName.frame.size.width - 1, 1.0f);
    bottomBorder2.backgroundColor = [UIColor grayColor].CGColor;
    
    CALayer *bottomBorder3 = [CALayer layer];
    bottomBorder3.frame = CGRectMake(0.0f, self.lastName.frame.size.height - 1, self.lastName.frame.size.width - 1, 1.0f);
    bottomBorder3.backgroundColor = [UIColor grayColor].CGColor;
    
    [self.dateOfBirth.layer addSublayer:bottomBorder];
    [self.firstName.layer addSublayer:bottomBorder2];
    [self.lastName.layer addSublayer:bottomBorder3];
}

- (IBAction)enterButtonPressed:(id)sender {
    [self.view endEditing:YES];
    //validate input
    if ([[self.firstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 || ![self.firstName.text canBeConvertedToEncoding:NSASCIIStringEncoding] || [[self.lastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 || ![self.lastName.text canBeConvertedToEncoding:NSASCIIStringEncoding] || [[self.dateOfBirth.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 || ![self.dateOfBirth.text canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        //drop down alert
        [RKDropdownAlert title:@"Login Failed" message:@"Please input valid information" backgroundColor:[UIColor colorWithRed:225.0/255.0 green:41.0/255.0 blue:57.0/255.0 alpha:0.8] textColor:[UIColor whiteColor] time:3];
        return;
    }
    //show progress indicator
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Verifying...";
    // match patient record
    [self getPatientInfo];
}


- (void)getPatientInfo {
    //generate request                     
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"https://drchrono.com/api/patients?verbose=true&last_name=%@&first_name=%@&date_of_birth=%@", [self.lastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], [self.firstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], self.dateOfBirth.text];
//    NSLog(@"url is %@", urlString);
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:self.headerValue forHTTPHeaderField:@"Authorization"];
    dispatch_queue_t fetchQ = dispatch_queue_create("fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//            NSLog(@"data is %@", data);
            if (data) {
                NSDictionary *requestReply = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
                //if there is no patient matched
//                NSLog(@"request reply is %@", requestReply);
                NSNumber *count = [requestReply objectForKey:@"count"];
//                NSLog(@"count is %@", count);
                if ([count intValue] == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [RKDropdownAlert title:@"Login Failed" message:@"No matched record found!" backgroundColor:[UIColor colorWithRed:225.0/255.0 green:41.0/255.0 blue:57.0/255.0 alpha:0.8] textColor:[UIColor whiteColor] time:3];
                        return;
                    });
                } else {
                    //find the patient in the appointment list
                    NSMutableDictionary *resultDictionary = [[requestReply objectForKey:@"results"] objectAtIndex:0];
                    self.patientInfo = [[NSMutableDictionary alloc]initWithDictionary:resultDictionary];
//                    NSLog(@"patient info: %@", self.patientInfo);
                    [self getAppointmentList];
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [RKDropdownAlert title:@"Error" message:@"Whitespace in the name or no internet connection, please try again!" backgroundColor:[UIColor colorWithRed:225.0/255.0 green:41.0/255.0 blue:57.0/255.0 alpha:0.8] textColor:[UIColor whiteColor] time:3];
                    return;
                });
            }
        }] resume];
    });
}


- (void)getAppointmentList {
    
    NSNumber *patientIdTobeMatched = [self.patientInfo objectForKey:@"id"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //    NSDate *date = [NSDate date];
    //    NSString *dateString = [[[date description] componentsSeparatedByString: @" "] objectAtIndex:0];
    // for convience, just use the appointments on 2016-04-19
    NSString *dateString = @"2016-04-19";
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
//                NSLog(@"result appointment is %@", results);
            for (NSDictionary *everyRecord in results) {
                NSNumber *patientId = [everyRecord objectForKey:@"patient"];
//                    NSLog(@"patientId every is %@", patientId);
                BOOL compare = [patientIdTobeMatched isEqualToNumber:patientId];
                if (compare) {
                    flag = 1;
                    // get reason and notes from appointment
                    [self.reason setString:[everyRecord objectForKey:@"reason"]];
                    [self.notes setString:[everyRecord objectForKey:@"notes"]];
                    self.appointmentId = [everyRecord objectForKey:@"id"];
//                        NSLog(@"note and reason is %@, %@", self.notes, self.reason);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self performSegueWithIdentifier:@"profilePhoto" sender:self];
                    });
                }
            }
            if (flag == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [RKDropdownAlert title:@"Login Failed" message:@"No appointment found, please make an appointment with the doctor first." backgroundColor:[UIColor colorWithRed:225.0/255.0 green:41.0/255.0 blue:57.0/255.0 alpha:0.8] textColor:[UIColor whiteColor] time:3];
                    return;
                });
            }
        }
    }] resume];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"profilePhoto"]) {
        PhotoViewController *vc = segue.destinationViewController;
        vc.patientInfo = self.patientInfo;
        vc.reason = self.reason;
        vc.notes = self.notes;
        vc.appointmentId = self.appointmentId;
    }
}

@end
