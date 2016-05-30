//
//  PrimaryInsuranceViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/22/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "PrimaryInsuranceViewController.h"
#import "SecondaryInsuranceViewController.h"
#import "EmergencyContactViewController.h"
#import "UIFloatLabelTextField.h"

@interface PrimaryInsuranceViewController ()
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *company;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *groupNumber;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *planName;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *insuranceID;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *cancel;

@end

@implementation PrimaryInsuranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.back.layer.cornerRadius = 5;
    self.next.layer.cornerRadius = 5;
    self.cancel.layer.cornerRadius = 5;
    [self setTextFieldText];
    [self setTextFieldUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)nextButtonPressed:(id)sender {
    // save changes in the memory
    [self saveChangesInMemory];
    // do segue
    [self performSegueWithIdentifier:@"showSecondaryInsurance" sender:self];
}

- (IBAction)backButtonPressed:(id)sender {
    [self saveChangesInMemory];
    [self performSegueWithIdentifier:@"backEmergencyContact" sender:self];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self alert];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - alert

- (void)alert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"If continue, all saved information will be lost" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:@"home7" sender:self];
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)saveChangesInMemory {
    [self.view endEditing:YES];
    [[self.patientInfo objectForKey:@"primary_insurance"] setObject:self.company.text forKey:@"insurance_company"];
    [[self.patientInfo objectForKey:@"primary_insurance"] setObject:self.groupNumber.text forKey:@"insurance_group_number"];
    [[self.patientInfo objectForKey:@"primary_insurance"] setObject:self.planName.text forKey:@"insurance_plan_name"];
    [[self.patientInfo objectForKey:@"primary_insurance"] setObject:self.insuranceID.text forKey:@"insurance_id_number"];
}

- (void)setTextFieldText {
    self.company.text = [[self.patientInfo objectForKey:@"primary_insurance"] objectForKey:@"insurance_company"];
    self.groupNumber.text = [[self.patientInfo objectForKey:@"primary_insurance"] objectForKey:@"insurance_group_number"];
    self.planName.text = [[self.patientInfo objectForKey:@"primary_insurance"] objectForKey:@"insurance_plan_name"];
    self.insuranceID.text = [[self.patientInfo objectForKey:@"primary_insurance"] objectForKey:@"insurance_id_number"];
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
    if ([[segue identifier] isEqualToString:@"showSecondaryInsurance"]) {
        SecondaryInsuranceViewController *vc = segue.destinationViewController;
        vc.patientInfo = self.patientInfo;
        vc.reason = self.reason;
        vc.notes = self.notes;
        vc.appointmentId = self.appointmentId;
    }
    
    if ([[segue identifier] isEqualToString:@"backEmergencyContact"]) {
        EmergencyContactViewController *vc = segue.destinationViewController;
        vc.patientInfo = self.patientInfo;
        vc.reason = self.reason;
        vc.notes = self.notes;
        vc.appointmentId = self.appointmentId;
    }
}

@end
