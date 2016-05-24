//
//  UserPasswordViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/23/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "UserPasswordViewController.h"
#import "UIFloatLabelTextField.h"
#import "RKDropdownAlert.h"

@interface UserPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *username;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *password;
@end

@implementation UserPasswordViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTextFieldUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)goButtonPressed:(id)sender {
    [self.view endEditing:YES];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:self.username.text] isEqualToString:self.password.text]) {
        // segue
        [self performSegueWithIdentifier:@"manage" sender:self];
    } else {
        // show alert
        [RKDropdownAlert title:@"Error" message:@"Please input valid information" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:3];
    }
}



- (void)setTextFieldUI {
    
    [self.username setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.username.floatLabelActiveColor = [UIColor orangeColor];
    self.username.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    [self.password setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.password.floatLabelActiveColor = [UIColor orangeColor];
    self.password.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    // set bottom border
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.username.frame.size.height - 1, self.username.frame.size.width - 1, 1.0f);
    bottomBorder.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder.borderWidth = 2 ;
    
    CALayer *bottomBorder2 = [CALayer layer];
    bottomBorder2.frame = CGRectMake(0.0f, self.password.frame.size.height - 1, self.password.frame.size.width - 1, 1.0f);
    bottomBorder2.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder2.borderWidth = 2 ;
    
    [self.username.layer addSublayer:bottomBorder];
    [self.password.layer addSublayer:bottomBorder2];
    
}


@end
