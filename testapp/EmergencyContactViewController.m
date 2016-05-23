//
//  EmergencyContactViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/22/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "EmergencyContactViewController.h"
#import "PrimaryInsuranceViewController.h"
#import "UIFloatLabelTextField.h"

@interface EmergencyContactViewController ()
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *name;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *phone;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *relation;

@end

@implementation EmergencyContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"emergencyview info list %@", self.patientInfo);
    [self setTextFieldText];
    [self setTextFieldUI];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)nextButtonPressed:(id)sender {
    [self.view endEditing:YES];
    
    
    // save changes in the memory
    [self.patientInfo setObject:self.name.text forKey:@"emergency_contact_name"];
    [self.patientInfo setObject:self.phone.text forKey:@"emergency_contact_phone"];
    [self.patientInfo setObject:self.relation.text forKey:@"emergency_contact_relation"];
    
    // do segue
    [self performSegueWithIdentifier:@"showPrimaryInsurance" sender:self];
    
}

- (void)setTextFieldText {
    
    self.name.text = [self.patientInfo objectForKey:@"emergency_contact_name"];
    self.phone.text = [self.patientInfo objectForKey:@"emergency_contact_phone"];
    self.relation.text = [self.patientInfo objectForKey:@"emergency_contact_relation"];
    
}


- (void)setTextFieldUI {
    
    [self.name setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.name.floatLabelActiveColor = [UIColor orangeColor];
    self.name.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    [self.phone setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.phone.floatLabelActiveColor = [UIColor orangeColor];
    self.phone.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    [self.relation setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.relation.floatLabelActiveColor = [UIColor orangeColor];
    self.relation.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    
    // set bottom border
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.name.frame.size.height - 1, self.name.frame.size.width - 1, 1.0f);
    bottomBorder.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder.borderWidth = 2 ;
    
    CALayer *bottomBorder2 = [CALayer layer];
    bottomBorder2.frame = CGRectMake(0.0f, self.phone.frame.size.height - 1, self.phone.frame.size.width - 1, 1.0f);
    bottomBorder2.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder2.borderWidth = 2 ;
    
    CALayer *bottomBorder3 = [CALayer layer];
    bottomBorder3.frame = CGRectMake(0.0f, self.relation.frame.size.height - 1, self.relation.frame.size.width - 1, 1.0f);
    bottomBorder3.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder3.borderWidth = 2 ;
    

    [self.name.layer addSublayer:bottomBorder];
    [self.phone.layer addSublayer:bottomBorder2];
    [self.relation.layer addSublayer:bottomBorder3];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showPrimaryInsurance"]) {
        UINavigationController *navi = segue.destinationViewController;
        PrimaryInsuranceViewController *vc = (PrimaryInsuranceViewController *)navi.topViewController;
        vc.patientInfo = self.patientInfo;
    }
}

@end