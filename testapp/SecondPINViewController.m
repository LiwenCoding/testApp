//
//  SecondPINViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/24/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "SecondPINViewController.h"
#import "UIFloatLabelTextField.h"
#import "RKDropdownAlert.h"

@interface SecondPINViewController ()
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *userPIN;
@property (weak, nonatomic) IBOutlet UIButton *enter;
@property (weak, nonatomic) IBOutlet UIButton *back;
@end

@implementation SecondPINViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enter.layer.cornerRadius = 5;
    self.back.layer.cornerRadius = 5;
    
    [self setTextFieldUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startAppButtonPressed:(id)sender {
    
    NSLog(@"pin is %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"PIN"]);
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"PIN"] isEqualToString:self.userPIN.text]) {
        [self performSegueWithIdentifier:@"showSettingPage" sender:self];
    } else {
        //drop down alert
        [RKDropdownAlert title:@"PIN entered is not correct" message:@"Please try again" backgroundColor:[UIColor colorWithRed:225.0/255.0 green:41.0/255.0 blue:57.0/255.0 alpha:0.8] textColor:[UIColor whiteColor] time:3];
    }
}


- (void)setTextFieldUI {
    
    [self.userPIN setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.userPIN.floatLabelActiveColor = [UIColor orangeColor];
    self.userPIN.floatLabelFont = [UIFont boldSystemFontOfSize:25];
    
    // set bottom border
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.userPIN.frame.size.height - 1, self.userPIN.frame.size.width - 1, 1.0f);
    bottomBorder.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder.borderWidth = 2 ;
    
    [self.userPIN.layer addSublayer:bottomBorder];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

@end
