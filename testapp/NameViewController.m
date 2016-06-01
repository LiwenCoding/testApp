//
//  NameViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/20/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "NameViewController.h"
#import "UIFloatLabelTextField.h"
#import "RKDropdownAlert.h"
#import "BackgroundInfoViewController.h"
#import "PhotoViewController.h"

@interface NameViewController ()
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *firstName;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *lastName;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *middleName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSelector;
@property (strong, nonatomic) NSString *gender;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@end

@implementation NameViewController

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

- (IBAction)genderSelector:(id)sender {
    switch (self.genderSelector.selectedSegmentIndex) {
        case 0:
            self.gender = @"Male";
            self.genderSelector.tintColor = [UIColor colorWithRed:67.0/255.0 green:152.0/255.0 blue:202.0/255.0 alpha:1];
            break;
        case 1:
            self.gender = @"Female";
            self.genderSelector.tintColor = [UIColor colorWithRed:222.0/255.0 green:114.0/255.0 blue:132.0/255.0 alpha:1];
            break;
        case 2:
            self.gender = @"Other";
            self.genderSelector.tintColor = [UIColor grayColor];
        default:
            break;
    }
}

- (IBAction)nextButtonPressed:(id)sender {
    [self.view endEditing:YES];
    // validate required field
    if ([[self.firstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 || ![self.firstName.text canBeConvertedToEncoding:NSASCIIStringEncoding] || [[self.lastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 || ![self.lastName.text canBeConvertedToEncoding:NSASCIIStringEncoding] ) {
        //drop down alert
        [RKDropdownAlert title:@"Error" message:@"Please input valid information" backgroundColor:[UIColor colorWithRed:225.0/255.0 green:41.0/255.0 blue:57.0/255.0 alpha:0.8] textColor:[UIColor whiteColor] time:3];
        return;
    }
    // save changes in the memory
    [self saveChangesInMemory];
    // do segue
    [self performSegueWithIdentifier:@"showBackgroundInfo" sender:self];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.view endEditing:YES];
    [self saveChangesInMemory];
    [self performSegueWithIdentifier:@"backPhoto" sender:self];
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
        [self performSegueWithIdentifier:@"home2" sender:self];
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)saveChangesInMemory {
    [self.patientInfo setObject:[self.firstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:@"first_name"];
    [self.patientInfo setObject:[self.lastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:@"last_name"];
    [self.patientInfo setObject:[self.middleName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:@"middle_name"];
    [self.patientInfo setObject:self.gender forKey:@"gender"];
}

- (void)setTextFieldText {
    self.firstName.text = [self.patientInfo objectForKey:@"first_name"];
    self.lastName.text = [self.patientInfo objectForKey:@"last_name"];
    self.middleName.text = [self.patientInfo objectForKey:@"middle_name"];
    // display gender
    NSString *genderInfo = [self.patientInfo objectForKey:@"gender"];
    if ([genderInfo isEqualToString:@""] || [genderInfo isEqualToString:@"Male"]) {
        self.gender = @"Male";
        self.genderSelector.selectedSegmentIndex = 0;
        self.genderSelector.tintColor = [UIColor colorWithRed:67.0/255.0 green:152.0/255.0 blue:202.0/255.0 alpha:1];
    } else if ([genderInfo isEqualToString:@"Female"]) {
        self.gender = @"Female";
        self.genderSelector.selectedSegmentIndex = 1;
        self.genderSelector.tintColor = [UIColor colorWithRed:222.0/255.0 green:114.0/255.0 blue:132.0/255.0 alpha:1];
    } else {
        self.gender = @"Other";
        self.genderSelector.selectedSegmentIndex = 2;
        self.genderSelector.tintColor = [UIColor grayColor];
    }
}

- (void)setTextFieldUI {
    [self.firstName setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.firstName.floatLabelActiveColor = [UIColor orangeColor];
    self.firstName.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    [self.lastName setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.lastName.floatLabelActiveColor = [UIColor orangeColor];
    self.lastName.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    
    [self.middleName setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.middleName.floatLabelActiveColor = [UIColor orangeColor];
    self.middleName.floatLabelFont = [UIFont boldSystemFontOfSize:15];
    // set bottom border
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.firstName.frame.size.height - 1, self.firstName.frame.size.width - 1, 1.0f);
    bottomBorder.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder.borderWidth = 2 ;
    
    CALayer *bottomBorder2 = [CALayer layer];
    bottomBorder2.frame = CGRectMake(0.0f, self.lastName.frame.size.height - 1, self.lastName.frame.size.width - 1, 1.0f);
    bottomBorder2.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder2.borderWidth = 2 ;
    
    CALayer *bottomBorder3 = [CALayer layer];
    bottomBorder3.frame = CGRectMake(0.0f, self.middleName.frame.size.height - 1, self.middleName.frame.size.width - 1, 1.0f);
    bottomBorder3.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder3.borderWidth = 2 ;
    
    [self.firstName.layer addSublayer:bottomBorder];
    [self.lastName.layer addSublayer:bottomBorder2];
    [self.middleName.layer addSublayer:bottomBorder3];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // next page
    if ([[segue identifier] isEqualToString:@"showBackgroundInfo"]) {
        BackgroundInfoViewController *vc = segue.destinationViewController;
        vc.patientInfo = self.patientInfo;
        vc.reason = self.reason;
        vc.notes = self.notes;
        vc.appointmentId = self.appointmentId;
    }
    // back page
    if ([[segue identifier] isEqualToString:@"backPhoto"]) {
        PhotoViewController *vc = segue.destinationViewController;
        vc.patientInfo = self.patientInfo;
        vc.reason = self.reason;
        vc.notes = self.notes;
        vc.appointmentId = self.appointmentId;
    }
}

@end
