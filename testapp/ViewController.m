//
//  ViewController.m
//  testapp
//
//  Created by Shen Liwen on 4/20/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic)NSString *headerValue;
@end

@implementation ViewController



- (IBAction)redirect:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://drchrono.com/o/authorize/?redirect_uri=http://127.0.0.1:8000/GroupOrder/default/test&response_type=code&client_id=V7jV4QDuGHjSMtIFc3BW4Rdaf4k1N2focgvGTxpj"]];
    }


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.headerValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerValue"];
//    NSLog(@"token in controller: %@", self.headerValue);
//    if (self.headerValue) {
//        [self performSegueWithIdentifier:@"initialView" sender:nil];
//        //        if ([segue.identifier isEqualToString:@"initialView"]) {
//        //        }
//    }
    
    

    
//    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CST"]];
//    NSDate* nDate = [NSDate date];
//    NSLog(@"%@", [nDate description]);
    
//    NSString *dateString = [self curentDateStringFromDate:[NSDate date] withFormat:@"dd-MM-yyyy"];
//    NSLog(@"date is @%", dateString);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//
//}

//- (NSString *)curentDateStringFromDate:(NSDate *)dateTimeInLine withFormat:(NSString *)dateFormat {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    
//    [formatter setDateFormat:dateFormat];
//    
//    NSString *convertedString = [formatter stringFromDate:dateTimeInLine];
//    
//    return convertedString;
//}





@end
