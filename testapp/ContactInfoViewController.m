//
//  ContactInfoViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/22/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "ContactInfoViewController.h"
#import "AddressViewController.h"
#import "UIFloatLabelTextField.h"

@interface ContactInfoViewController ()
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *homePhone;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *cellPhone;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *emailAddress;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *workPhone;

@end

@implementation ContactInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"contactview info list %@", self.patientInfo);
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
    [self.patientInfo setObject:self.homePhone.text forKey:@"home_phone"];
    [self.patientInfo setObject:self.cellPhone.text forKey:@"cell_phone"];
    [self.patientInfo setObject:self.emailAddress.text forKey:@"email"];
    [self.patientInfo setObject:self.workPhone forKey:@"office_phone"];
    
    // do segue
    [self performSegueWithIdentifier:@"showAddress" sender:self];
    
}

- (void)setTextFieldText {
    
    self.homePhone.text = [self.patientInfo objectForKey:@"home_phone"];
    self.cellPhone.text = [self.patientInfo objectForKey:@"cell_phone"];
    self.emailAddress.text = [self.patientInfo objectForKey:@"email"];
    self.workPhone.text = [self.patientInfo objectForKey:@"office_phone"];
    
}


- (void)setTextFieldUI {
    
    [self.homePhone setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.homePhone.floatLabelActiveColor = [UIColor orangeColor];
    self.homePhone.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    [self.cellPhone setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.cellPhone.floatLabelActiveColor = [UIColor orangeColor];
    self.cellPhone.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    [self.emailAddress setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.emailAddress.floatLabelActiveColor = [UIColor orangeColor];
    self.emailAddress.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    [self.workPhone setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.workPhone.floatLabelActiveColor = [UIColor orangeColor];
    self.workPhone.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    
    // set bottom border
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.homePhone.frame.size.height - 1, self.homePhone.frame.size.width - 1, 1.0f);
    bottomBorder.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder.borderWidth = 2 ;
    
    CALayer *bottomBorder2 = [CALayer layer];
    bottomBorder2.frame = CGRectMake(0.0f, self.cellPhone.frame.size.height - 1, self.cellPhone.frame.size.width - 1, 1.0f);
    bottomBorder2.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder2.borderWidth = 2 ;
    
    CALayer *bottomBorder3 = [CALayer layer];
    bottomBorder3.frame = CGRectMake(0.0f, self.emailAddress.frame.size.height - 1, self.emailAddress.frame.size.width - 1, 1.0f);
    bottomBorder3.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder3.borderWidth = 2 ;
    
    CALayer *bottomBorder4 = [CALayer layer];
    bottomBorder4.frame = CGRectMake(0.0f, self.workPhone.frame.size.height - 1, self.workPhone.frame.size.width - 1, 1.0f);
    bottomBorder4.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder4.borderWidth = 2 ;
    
    
    
    [self.homePhone.layer addSublayer:bottomBorder];
    [self.cellPhone.layer addSublayer:bottomBorder2];
    [self.emailAddress.layer addSublayer:bottomBorder3];
    [self.workPhone.layer addSublayer:bottomBorder4];
    
}




#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showAddress"]) {
        UINavigationController *navi = segue.destinationViewController;
        AddressViewController *vc = (AddressViewController *)navi.topViewController;
        vc.patientInfo = self.patientInfo;
    }
}

@end
