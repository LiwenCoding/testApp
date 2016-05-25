//
//  AddressViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/22/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "AddressViewController.h"
#import "EmergencyContactViewController.h"
#import "UIFloatLabelTextField.h"
#import "RKDropdownAlert.h"
#import "ContactInfoViewController.h"

@interface AddressViewController ()
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *address;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *zipCode;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *state;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *city;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIButton *cancel;

@property (weak, nonatomic) IBOutlet UIButton *back;
@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"addressview info list %@", self.patientInfo);
    self.back.layer.cornerRadius = 5;
    self.next.layer.cornerRadius = 5;
    self.cancel.layer.cornerRadius = 5;
    [self setTextFieldText];
    [self setTextFieldUI];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)nextButtonPressed:(id)sender {
    
    //validate input
    if ([[self.address.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 || ![self.address.text canBeConvertedToEncoding:NSASCIIStringEncoding] || [[self.zipCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 || ![self.zipCode.text canBeConvertedToEncoding:NSASCIIStringEncoding] || [[self.state.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 || ![self.state.text canBeConvertedToEncoding:NSASCIIStringEncoding] || [[self.city.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 || ![self.city.text canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        //drop down alert
        [RKDropdownAlert title:@"Error" message:@"Please input valid information" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:3];
        return;
    }
    
    // save changes in the memory
    [self saveChangesInMemory];
    
    // do segue
    [self performSegueWithIdentifier:@"showEmergencyContact" sender:self];
    
}


- (IBAction)backButtonPressed:(id)sender {
    [self saveChangesInMemory];
    [self performSegueWithIdentifier:@"backContactInfo" sender:self];
    
}


- (IBAction)cancelButtonPressed:(id)sender {
    
    [self alert];
    
}

#pragma mark - alert

- (void)alert {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"If continue, all saved information will be lost" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:@"home5" sender:self];
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)saveChangesInMemory {
    [self.view endEditing:YES];

    [self.patientInfo setObject:self.address.text forKey:@"address"];
    [self.patientInfo setObject:self.zipCode.text forKey:@"zip_code"];
    [self.patientInfo setObject:self.state.text forKey:@"state"];
    [self.patientInfo setObject:self.city.text forKey:@"city"];
}


- (void)setTextFieldText {
    
    self.address.text = [self.patientInfo objectForKey:@"address"];
    self.zipCode.text = [self.patientInfo objectForKey:@"zip_code"];
    self.state.text = [self.patientInfo objectForKey:@"state"];
    self.city.text = [self.patientInfo objectForKey:@"city"];
    
}


- (void)setTextFieldUI {
    
    [self.address setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.address.floatLabelActiveColor = [UIColor orangeColor];
    self.address.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    [self.zipCode setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.zipCode.floatLabelActiveColor = [UIColor orangeColor];
    self.zipCode.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    [self.state setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.state.floatLabelActiveColor = [UIColor orangeColor];
    self.state.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    [self.city setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.city.floatLabelActiveColor = [UIColor orangeColor];
    self.city.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    
    // set bottom border
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.address.frame.size.height - 1, self.address.frame.size.width - 1, 1.0f);
    bottomBorder.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder.borderWidth = 2 ;
    
    CALayer *bottomBorder2 = [CALayer layer];
    bottomBorder2.frame = CGRectMake(0.0f, self.zipCode.frame.size.height - 1, self.zipCode.frame.size.width - 1, 1.0f);
    bottomBorder2.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder2.borderWidth = 2 ;
    
    CALayer *bottomBorder3 = [CALayer layer];
    bottomBorder3.frame = CGRectMake(0.0f, self.state.frame.size.height - 1, self.state.frame.size.width - 1, 1.0f);
    bottomBorder3.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder3.borderWidth = 2 ;
    
    CALayer *bottomBorder4 = [CALayer layer];
    bottomBorder4.frame = CGRectMake(0.0f, self.city.frame.size.height - 1, self.city.frame.size.width - 1, 1.0f);
    bottomBorder4.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder4.borderWidth = 2 ;
    
    
    
    [self.address.layer addSublayer:bottomBorder];
    [self.zipCode.layer addSublayer:bottomBorder2];
    [self.state.layer addSublayer:bottomBorder3];
    [self.city.layer addSublayer:bottomBorder4];
    
}









#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showEmergencyContact"]) {
        EmergencyContactViewController *vc = segue.destinationViewController;
        vc.patientInfo = self.patientInfo;
    }
    
    if ([[segue identifier] isEqualToString:@"backContactInfo"]) {
        ContactInfoViewController *vc = segue.destinationViewController;
        vc.patientInfo = self.patientInfo;
        
    }
}

@end
