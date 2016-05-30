//
//  ReasonViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/29/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "ReasonViewController.h"
#import "MedicationTableViewController.h"
#import "MBProgressHUD.h"
#import "RKDropdownAlert.h"

@interface ReasonViewController ()
@property (weak, nonatomic) IBOutlet UITextView *notesText;
@property (weak, nonatomic) IBOutlet UITextView *reasonText;
@property (strong, nonatomic) NSString *headerValue;
@property (weak, nonatomic) IBOutlet UIButton *finish;
@property (weak, nonatomic) IBOutlet UIButton *back;
@end

@implementation ReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.notesText.layer.cornerRadius = 5.0;
    self.notesText.clipsToBounds = YES;
    self.reasonText.layer.cornerRadius = 5.0;
    self.reasonText.clipsToBounds = YES;
    self.back.layer.cornerRadius = 5;
    self.finish.layer.cornerRadius = 5;
    self.notesText.text = self.notes;
    self.reasonText.text = self.reason;
    self.headerValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerValue"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)backButtonPressed:(id)sender {
    [self saveInformationToMemory];
    [self performSegueWithIdentifier:@"backMedication" sender:self];
}

- (IBAction)finishButtonPressed:(id)sender {
    // save reason and notes in memeory
    [self saveInformationToMemory];
    // save all infor to server
    [self saveAllInformationToServer];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self alert];
}

-(void)saveInformationToMemory {
    [self.notes setString:self.notesText.text];
    [self.reason setString:self.reasonText.text];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)saveAllInformationToServer {
    // show progress indicator
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Saving...";
    // generate request
    [self.patientInfo removeObjectsForKeys:@[@"tertiary_insurance", @"patient_photo", @"patient_photo_date", @123, @3.14]];
//    NSLog(@"serialized dictionary is %@", self.patientInfo);
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:self.patientInfo options:0 error:&error];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *url = [NSString stringWithFormat:@"https://drchrono.com/api/patients/%@", [self.patientInfo objectForKey:@"id"]];
//    NSLog(@"url is : %@", url);
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
                    // save reason and notes to server
                    [self saveReasonToServer];
                } else {
                    //post failure
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [RKDropdownAlert title:@"Save Failed" message:@"Please try later!" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:3];
                        return;
                    });
                }
//                NSLog(@"patch response is : %@", requestReply);
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [RKDropdownAlert title:@"Error" message:@"No internet connection, please try later!" backgroundColor:[UIColor colorWithRed:44.0/255.0 green:192.0/255.0 blue:83.0/255.0 alpha:0.8] textColor:[UIColor whiteColor] time:3];
                    return;
                });
            }
        }] resume];
    });
}

-(void)saveReasonToServer{
    NSError *error;
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys: self.notesText.text, @"notes", self.reasonText.text, @"reason", @"Arrived", @"status",
                         nil];
//    NSLog(@"tmp is %@", tmp);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *url = [NSString stringWithFormat:@"https://drchrono.com/api/appointments/%@", self.appointmentId];
//    NSLog(@"url is : %@", url);
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"PATCH"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:self.headerValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:postData];
    dispatch_queue_t fetchQ2 = dispatch_queue_create("fetcher", NULL);
    dispatch_async(fetchQ2, ^{
        NSURLSession *session2 = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session2 dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (data) {
                NSDictionary *requestReply = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error: &error];
                if ([requestReply objectForKey:@"id"]) {
                    //post success
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [RKDropdownAlert title:@"Success" message:@"All information has been succussfully saved!" backgroundColor:[UIColor colorWithRed:44.0/255.0 green:192.0/255.0 blue:83.0/255.0 alpha:0.8] textColor:[UIColor whiteColor] time:3];
                        // go to finish page
                        [self performSegueWithIdentifier:@"finish" sender:self];
                    });
                } else {
                    //post failure
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [RKDropdownAlert title:@"Save Failed" message:@"Please try later!" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:3];
                    });
                }
//                NSLog(@"patch response is : %@", requestReply);
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

#pragma mark - alert

- (void)alert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"If continue, all saved information will be lost" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:@"home9" sender:self];
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"backMedication"]) {
        MedicationTableViewController *vc = segue.destinationViewController;
        vc.patientInfo = self.patientInfo;
        vc.reason = self.reason;
        vc.notes = self.notes;
        vc.appointmentId = self.appointmentId;
    }
}

@end
