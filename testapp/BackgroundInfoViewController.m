//
//  BackgroundInfoViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/21/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "BackgroundInfoViewController.h"
#import "UIFloatLabelTextField.h"
#import "RaceSelectionTableViewController.h"
#import "LanguageSelectionTableViewController.h"
#import "EthnicitySelectionTableViewController.h"
#import "ContactInfoViewController.h"
#import "RKDropdownAlert.h"
#import "NameViewController.h"

@interface BackgroundInfoViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *dateOfBirth;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *preferredLanguage;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *race;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *ethnicity;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *socialSecurity;

@end

@implementation BackgroundInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateOfBirth.delegate = self;
    self.race.delegate = self;
    self.preferredLanguage.delegate = self;
    self.ethnicity.delegate = self;
    NSLog(@"backgroundview info list %@", self.patientInfo);
    [self setTextFieldText];
    [self setTextFieldUI];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButtonPressed:(id)sender {

    [self saveChangesInMemory];
    // do segue
    [self performSegueWithIdentifier:@"showContactInfo" sender:self];
    
}

- (IBAction)backButtonPressed:(id)sender {
    [self saveChangesInMemory];
    [self performSegueWithIdentifier:@"backName" sender:self];
    
}

- (void)saveChangesInMemory {
    [self.view endEditing:YES];
    
    // validate required field
    if ([[self.dateOfBirth.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 || ![self.dateOfBirth.text canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        //drop down alert
        [RKDropdownAlert title:@"Error" message:@"Please fill the valid date of birth" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:3];
        return;
    }
    
    // save changes in the memory
    [self.patientInfo setObject:self.dateOfBirth.text forKey:@"date_of_birth"];
    
    if (![self.preferredLanguage.text isEqualToString:@""]) {
        [self.patientInfo setObject:self.preferredLanguage.text forKey:@"preferred_language"];
    }
    
    if (![self.race.text isEqualToString:@""]) {
        [self.patientInfo setObject:self.race.text forKey:@"race"];
    }
    
    if (![self.ethnicity.text isEqualToString:@""]) {
        [self.patientInfo setObject:self.ethnicity.text forKey:@"ethnicity"];
    }
    
    if (![self.ethnicity.text isEqualToString:@""]) {
        [self.patientInfo setObject:self.socialSecurity.text forKey:@"social_security_number"];
    }
}





- (void)setTextFieldText {
    
    self.dateOfBirth.text = [self.patientInfo objectForKey:@"date_of_birth"];
    
    if ([[self.patientInfo objectForKey:@"preferred_language"] isEqualToString:@"blank"]) {
        self.preferredLanguage.text = @"";
    } else {
        self.preferredLanguage.text = [self.patientInfo objectForKey:@"preferred_language"];
    }
    
    if ([[self.patientInfo objectForKey:@"race"] isEqualToString:@"blank"]) {
        self.race.text = @"";
    } else {
        self.race.text = [self.patientInfo objectForKey:@"race"];
    }
    
    if ([[self.patientInfo objectForKey:@"ethnicity"] isEqualToString:@"blank"]) {
        self.ethnicity.text = @"";
    } else {
        self.ethnicity.text = [self.patientInfo objectForKey:@"ethnicity"];
    }
    
    if ([[self.patientInfo objectForKey:@"social_security_number"] isEqualToString:@"blank"]) {
        self.socialSecurity.text = @"";
    } else {
        self.socialSecurity.text = [self.patientInfo objectForKey:@"social_security_number"];
    }

}


- (void)editDidBegin {
    if (self.dateOfBirth.inputView == nil) {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(updateTextField:)
             forControlEvents:UIControlEventValueChanged];
        [self.dateOfBirth setInputView:datePicker];
        UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        [toolBar setTintColor:[UIColor grayColor]];
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed)];
        UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
        [self.dateOfBirth setInputAccessoryView:toolBar];
    }
}


-(void)updateTextField:(UIDatePicker *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.dateOfBirth.text = [formatter stringFromDate:sender.date];
}

-(void)doneButtonPressed {
    [self.dateOfBirth resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}


- (BOOL)textFieldShouldBeginEditing:(UIFloatLabelTextField *) textField
{
    
    if (textField == self.race) {
        [self.view endEditing:YES];
        [self performSegueWithIdentifier:@"showRacePopover" sender:self];
    } else if (textField == self.dateOfBirth) {
        [self editDidBegin];
        return YES;
    } else if (textField == self.preferredLanguage) {
        [self.view endEditing:YES];
        [self performSegueWithIdentifier:@"showLanguagePopover" sender:self];
    } else if (textField == self.ethnicity) {
        [self.view endEditing:YES];
        [self performSegueWithIdentifier:@"showEthnicityPopover" sender:self];
    }

    return NO;
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
    bottomBorder2.frame = CGRectMake(0.0f, self.socialSecurity.frame.size.height - 1, self.socialSecurity.frame.size.width - 1, 1.0f);
    bottomBorder2.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder2.borderWidth = 2;
    
    CALayer *bottomBorder3 = [CALayer layer];
    bottomBorder3.frame = CGRectMake(0.0f, self.preferredLanguage.frame.size.height - 1, self.preferredLanguage.frame.size.width - 1, 1.0f);
    bottomBorder3.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder3.borderWidth = 2;
    
    CALayer *bottomBorder4 = [CALayer layer];
    bottomBorder4.frame = CGRectMake(0.0f, self.race.frame.size.height - 1, self.race.frame.size.width - 1, 1.0f);
    bottomBorder4.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder4.borderWidth = 2;
    
    CALayer *bottomBorder5 = [CALayer layer];
    bottomBorder5.frame = CGRectMake(0.0f, self.ethnicity.frame.size.height - 1, self.ethnicity.frame.size.width - 1, 1.0f);
    bottomBorder5.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder5.borderWidth = 2;

    
    [self.dateOfBirth.layer addSublayer:bottomBorder];
    [self.preferredLanguage.layer addSublayer:bottomBorder3];
    [self.race.layer addSublayer:bottomBorder4];
    [self.ethnicity.layer addSublayer:bottomBorder5];
    [self.socialSecurity.layer addSublayer:bottomBorder2];
    
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // get data from popovers
    if ([[segue identifier] isEqualToString:@"showRacePopover"]) {
        UINavigationController *navi = segue.destinationViewController;
        RaceSelectionTableViewController *vc = (RaceSelectionTableViewController *)navi.topViewController;
        vc.selectionHappenedInPopoverVC = ^(NSString *responseRace) {
            //get selection result
            self.race.text = responseRace;
            // dissmiss popover view
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    } else if ([[segue identifier] isEqualToString:@"showLanguagePopover"]) {
        UINavigationController *navi = segue.destinationViewController;
        LanguageSelectionTableViewController *vc = (LanguageSelectionTableViewController *)navi.topViewController;
        vc.selectionHappenedInPopoverVC = ^(NSString *responseLanguage) {
            //get selection result
            self.preferredLanguage.text = responseLanguage;
            // dissmiss popover view
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    } else if ([[segue identifier] isEqualToString:@"showEthnicityPopover"]) {
        UINavigationController *navi = segue.destinationViewController;
        EthnicitySelectionTableViewController *vc = (EthnicitySelectionTableViewController *)navi.topViewController;
        vc.selectionHappenedInPopoverVC = ^(NSString *responseEthnicity) {
            //get selection result
            self.ethnicity.text = responseEthnicity;
            // dissmiss popover view
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }

    // prepare data for next segue
    
    if ([[segue identifier] isEqualToString:@"showContactInfo"]) {
        UINavigationController *navi = segue.destinationViewController;
        ContactInfoViewController *vc = (ContactInfoViewController *)navi.topViewController;
        vc.patientInfo = self.patientInfo;
    }
    
    
    if ([[segue identifier] isEqualToString:@"backName"]) {
        NameViewController *vc = segue.destinationViewController;
        vc.patientInfo = self.patientInfo;
        
    }
    
    
}

@end
