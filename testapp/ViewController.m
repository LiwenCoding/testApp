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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
