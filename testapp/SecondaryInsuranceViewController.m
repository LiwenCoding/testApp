//
//  SecondaryInsuranceViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/22/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "SecondaryInsuranceViewController.h"
#import "UIFloatLabelTextField.h"
#import "AllergyTableViewController.h"

@interface SecondaryInsuranceViewController ()
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *company;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *insuranceID;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *groupNumber;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *planName;
@end

@implementation SecondaryInsuranceViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"insurance2view info list %@", self.patientInfo);
    [self setTextFieldText];
    [self setTextFieldUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)nextButtonPressed:(id)sender {
    [self.view endEditing:YES];
    
    
    // save changes in the memory
    [[self.patientInfo objectForKey:@"secondary_insurance"] setObject:self.company.text forKey:@"insurance_company"];
    [[self.patientInfo objectForKey:@"secondary_insurance"] setObject:self.groupNumber.text forKey:@"insurance_group_number"];
    [[self.patientInfo objectForKey:@"secondary_insurance"] setObject:self.planName.text forKey:@"insurance_group_number"];
    [[self.patientInfo objectForKey:@"secondary_insurance"] setObject:self.insuranceID.text forKey:@"insurance_id_number"];
    
    
    NSLog(@"saved info is %@", [self.patientInfo objectForKey:@"secondary_insurance"]);
    
    // do segue
    [self performSegueWithIdentifier:@"showAllergy" sender:self];
        

    
}

- (void)setTextFieldText {
    
    NSLog(@"insurance info is %@", [self.patientInfo objectForKey:@"secondary_insurance"]);
    self.company.text = [[self.patientInfo objectForKey:@"secondary_insurance"] objectForKey:@"insurance_company"];
    self.groupNumber.text = [[self.patientInfo objectForKey:@"secondary_insurance"] objectForKey:@"insurance_group_number"];
    self.planName.text = [[self.patientInfo objectForKey:@"secondary_insurance"] objectForKey:@"insurance_plan_name"];
    self.insuranceID.text = [[self.patientInfo objectForKey:@"secondary_insurance"] objectForKey:@"insurance_id_number"];
    
    
}


- (void)setTextFieldUI {
    
    [self.company setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.company.floatLabelActiveColor = [UIColor orangeColor];
    self.company.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    [self.groupNumber setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.groupNumber.floatLabelActiveColor = [UIColor orangeColor];
    self.groupNumber.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    [self.planName setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.planName.floatLabelActiveColor = [UIColor orangeColor];
    self.planName.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    [self.insuranceID setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.insuranceID.floatLabelActiveColor = [UIColor orangeColor];
    self.insuranceID.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    // set bottom border
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.company.frame.size.height - 1, self.company.frame.size.width - 1, 1.0f);
    bottomBorder.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder.borderWidth = 2 ;
    
    CALayer *bottomBorder2 = [CALayer layer];
    bottomBorder2.frame = CGRectMake(0.0f, self.groupNumber.frame.size.height - 1, self.groupNumber.frame.size.width - 1, 1.0f);
    bottomBorder2.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder2.borderWidth = 2 ;
    
    CALayer *bottomBorder3 = [CALayer layer];
    bottomBorder3.frame = CGRectMake(0.0f, self.planName.frame.size.height - 1, self.planName.frame.size.width - 1, 1.0f);
    bottomBorder3.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder3.borderWidth = 2 ;
    
    CALayer *bottomBorder4 = [CALayer layer];
    bottomBorder4.frame = CGRectMake(0.0f, self.insuranceID.frame.size.height - 1, self.insuranceID.frame.size.width - 1, 1.0f);
    bottomBorder4.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder4.borderWidth = 2 ;
    
    [self.company.layer addSublayer:bottomBorder];
    [self.groupNumber.layer addSublayer:bottomBorder2];
    [self.planName.layer addSublayer:bottomBorder3];
    [self.insuranceID.layer addSublayer:bottomBorder4];
    
    
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showAllergy"]) {
        UINavigationController *navi = segue.destinationViewController;
        AllergyTableViewController *vc = (AllergyTableViewController *)navi.topViewController;
        vc.patientInfo = self.patientInfo;
    }
}

@end
