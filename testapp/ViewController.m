//
//  ViewController.m
//  testapp
//
//  Created by Shen Liwen on 4/20/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *redirect;
@property (weak, nonatomic) IBOutlet UIButton *check;
@property (weak, nonatomic) IBOutlet UIButton *start;
@property (strong, nonatomic)NSString *headerValue;
@end

@implementation ViewController

- (IBAction)redirect:(id)sender {
//    self.headerValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerValue"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://drchrono.com/o/authorize/?redirect_uri=http://127.0.0.1:8000/GroupOrder/default/test&response_type=code&client_id=V7jV4QDuGHjSMtIFc3BW4Rdaf4k1N2focgvGTxpj"]];
    }





- (void)viewDidLoad {
    [super viewDidLoad];
    self.redirect.layer.cornerRadius = 5;
    self.check.layer.cornerRadius = 5;
    self.start.layer.cornerRadius = 5;




}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
