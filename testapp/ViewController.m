//
//  ViewController.m
//  testapp
//
//  Created by Shen Liwen on 4/20/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "ViewController.h"
#import "RKDropdownAlert.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *redirect;
@property (weak, nonatomic) IBOutlet UIButton *check;
@property (weak, nonatomic) IBOutlet UIButton *start;
@property (strong, nonatomic)NSString *headerValue;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.redirect.layer.cornerRadius = 5;
    self.check.layer.cornerRadius = 5;
    self.start.layer.cornerRadius = 5;
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)redirect:(id)sender {
    // send request for access token
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://drchrono.com/o/authorize/?redirect_uri=http://127.0.0.1:8000/GroupOrder/default/test&response_type=code&client_id=V7jV4QDuGHjSMtIFc3BW4Rdaf4k1N2focgvGTxpj"]];
}

- (IBAction)startAppButtonPressed:(id)sender {
    self.headerValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerValue"];
    NSLog(@"header value is %@", self.headerValue);
    
    if(self.headerValue) {
        [self performSegueWithIdentifier:@"startApp" sender:self];
    } else {
        //drop down alert
        [RKDropdownAlert title:@"Notice" message:@"Please connect with Drchrono first!" backgroundColor:[UIColor colorWithRed:225.0/255.0 green:41.0/255.0 blue:57.0/255.0 alpha:0.8] textColor:[UIColor whiteColor] time:3];
    }
}


- (IBAction)checkAppointmentButtonPressed:(id)sender {
    self.headerValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerValue"];
    if(self.headerValue) {
        [self performSegueWithIdentifier:@"PINPage" sender:self];
    } else {
        //drop down alert
        [RKDropdownAlert title:@"Notice" message:@"Please connect with Drchrono first!" backgroundColor:[UIColor colorWithRed:225.0/255.0 green:41.0/255.0 blue:57.0/255.0 alpha:0.8] textColor:[UIColor whiteColor] time:3];
    }
    
}


@end
