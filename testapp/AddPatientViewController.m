//
//  AddPatientViewController.m
//  testapp
//
//  Created by Shen Liwen on 4/21/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "AddPatientViewController.h"

@interface AddPatientViewController () <UITextViewDelegate>
@property (strong, nonatomic) NSString *headerValue;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSelector;

@end

@implementation AddPatientViewController

- (IBAction)genderSelector:(id)sender {
    
    switch (self.genderSelector.selectedSegmentIndex)
    {
    case 0:
        self.gender = @"Male";
            break;
    case 1:
        self.gender = @"Female";
            break;
    default:
        break; 
    }
}

- (IBAction)createButton:(id)sender {
    
    [self addPatient];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerValue"];
    self.gender = @"Male";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void)addPatient {
    
    NSString *doctor = @"89784";
    NSString *birth = @"1988-12-12";
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys: self.firstName.text, @"first_name", self.lastName.text, @"last_name", self.phoneNumber.text, @"cell_phone",self.gender, @"gender", doctor, @"doctor", birth, @"date_of_birth",
                         nil];

    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://drchrono.com/api/patients"]];
    [request setHTTPMethod:@"POST"];
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
                NSLog(@"requestReply: %@", [requestReply objectForKey:@"id"]);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.tableView reloadData];
                    //go to main page
//                });
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
