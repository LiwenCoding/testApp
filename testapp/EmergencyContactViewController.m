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
#import "AddressViewController.h"

@interface EmergencyContactViewController ()
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *name;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *phone;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *relation;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@end

@implementation EmergencyContactViewController

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
    [self performSegueWithIdentifier:@"showPrimaryInsurance" sender:self];
}

- (IBAction)backButtonPressed:(id)sender {
    [self saveChangesInMemory];
    [self performSegueWithIdentifier:@"backAddress" sender:self];
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
        [self performSegueWithIdentifier:@"home6" sender:self];
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)saveChangesInMemory {
    [self.view endEditing:YES];
    [self.patientInfo setObject:self.name.text forKey:@"emergency_contact_name"];
    [self.patientInfo setObject:self.phone.text forKey:@"emergency_contact_phone"];
    [self.patientInfo setObject:self.relation.text forKey:@"emergency_contact_relation"];
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
        PrimaryInsuranceViewController *vc =  segue.destinationViewController;
        vc.patientInfo = self.patientInfo;
        vc.reason = self.reason;
        vc.notes = self.notes;
        vc.appointmentId = self.appointmentId;
    }
    
    if ([[segue identifier] isEqualToString:@"backAddress"]) {
        AddressViewController *vc = segue.destinationViewController;
        vc.patientInfo = self.patientInfo;
        vc.reason = self.reason;
        vc.notes = self.notes;
        vc.appointmentId = self.appointmentId;
    }
}

@end
