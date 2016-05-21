//
//  BackgroundInfoViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/21/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "BackgroundInfoViewController.h"
#import "UIFloatLabelTextField.h"

@interface BackgroundInfoViewController ()
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *dateOfBirth;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *preferredLanguage;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *race;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *ethnicity;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *socialSecurity;

@end

@implementation BackgroundInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"backgroundview info list %@", self.patientInfo);
    [self setTextFieldText];
    [self setTextFieldUI];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setTextFieldText {
    
    self.dateOfBirth.text = [self.patientInfo objectForKey:@"date_of_birth"];
    self.preferredLanguage.text = [self.patientInfo objectForKey:@"preferred_language"];
    self.race.text = [self.patientInfo objectForKey:@"race"];
    self.ethnicity.text = [self.patientInfo objectForKey:@"ethnicity"];
    self.socialSecurity.text = [self.patientInfo objectForKey:@"social_security_number"];

}


- (void)setTextFieldUI {
    
    [self.dateOfBirth setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.dateOfBirth.floatLabelActiveColor = [UIColor orangeColor];
    self.dateOfBirth.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    [self.preferredLanguage setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.preferredLanguage.floatLabelActiveColor = [UIColor orangeColor];
    self.preferredLanguage.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    [self.race setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.race.floatLabelActiveColor = [UIColor orangeColor];
    self.race.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    [self.ethnicity setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.ethnicity.floatLabelActiveColor = [UIColor orangeColor];
    self.ethnicity.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    [self.socialSecurity setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.socialSecurity.floatLabelActiveColor = [UIColor orangeColor];
    self.socialSecurity.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    // set bottom border
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.dateOfBirth.frame.size.height - 1, self.dateOfBirth.frame.size.width - 1, 1.0f);
    bottomBorder.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder.borderWidth = 2;
        
    CALayer *bottomBorder2 = [CALayer layer];
    bottomBorder2.frame = CGRectMake(0.0f, self.dateOfBirth.frame.size.height - 1, self.dateOfBirth.frame.size.width - 1, 1.0f);
    bottomBorder2.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder2.borderWidth = 2;
    
    CALayer *bottomBorder3 = [CALayer layer];
    bottomBorder3.frame = CGRectMake(0.0f, self.dateOfBirth.frame.size.height - 1, self.dateOfBirth.frame.size.width - 1, 1.0f);
    bottomBorder3.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder3.borderWidth = 2;
    
    CALayer *bottomBorder4 = [CALayer layer];
    bottomBorder4.frame = CGRectMake(0.0f, self.dateOfBirth.frame.size.height - 1, self.dateOfBirth.frame.size.width - 1, 1.0f);
    bottomBorder4.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder4.borderWidth = 2;
    
    CALayer *bottomBorder5 = [CALayer layer];
    bottomBorder5.frame = CGRectMake(0.0f, self.dateOfBirth.frame.size.height - 1, self.dateOfBirth.frame.size.width - 1, 1.0f);
    bottomBorder5.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder5.borderWidth = 2;

    
    [self.dateOfBirth.layer addSublayer:bottomBorder];
    [self.preferredLanguage.layer addSublayer:bottomBorder2];
    [self.race.layer addSublayer:bottomBorder3];
    [self.ethnicity.layer addSublayer:bottomBorder4];
    [self.socialSecurity.layer addSublayer:bottomBorder5];
    
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
