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

@interface NameViewController ()
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *firstName;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *lastName;
@property (weak, nonatomic) IBOutlet UIFloatLabelTextField *middleName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSelector;
@property (strong, nonatomic) NSString *gender;

@end

@implementation NameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"nameview info list %@", self.patientInfo);
    [self setTextFieldText];
    [self setTextFieldUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)genderSelector:(id)sender {
    
    switch (self.genderSelector.selectedSegmentIndex)
    {
        case 0:
            self.gender = @"Male";
            [self.genderSelector setTintColor:[UIColor greenColor]];
            NSLog(@"gender is %@", self.gender);
            break;
        case 1:
            self.gender = @"Female";
            [self.genderSelector setTintColor:[UIColor redColor]];

            NSLog(@"gender is %@", self.gender);

            break;
        case 2:
            self.gender = @"Other";
            [self.genderSelector setTintColor:[UIColor grayColor]];

        default:
            break;
    }
}
- (IBAction)nextButtonPressed:(id)sender {
    [self.view endEditing:YES];
    
    // validate required field
    if ([[self.firstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 || ![self.firstName.text canBeConvertedToEncoding:NSASCIIStringEncoding] || [[self.lastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 || ![self.lastName.text canBeConvertedToEncoding:NSASCIIStringEncoding] ) {
        //drop down alert
        [RKDropdownAlert title:@"Error" message:@"Please input valid information" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:3];
        return;
    }
    
    // save changes in the memory
    [self.patientInfo setObject:self.firstName.text forKey:@"first_name"];
    [self.patientInfo setObject:self.lastName.text forKey:@"last_name"];
    [self.patientInfo setObject:self.middleName.text forKey:@"middle_name"];
    [self.patientInfo setObject:self.gender forKey:@"gender"];


    // do segue
    [self performSegueWithIdentifier:@"showBackgroundInfo" sender:self];

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
    } else if ([genderInfo isEqualToString:@"Female"]) {
        self.gender = @"Female";
        self.genderSelector.selectedSegmentIndex = 1;
    } else {
        self.gender = @"Other";
        self.genderSelector.selectedSegmentIndex = 2;
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
    bottomBorder2.frame = CGRectMake(0.0f, self.firstName.frame.size.height - 1, self.firstName.frame.size.width - 1, 1.0f);
    bottomBorder2.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder2.borderWidth = 2 ;
    
    CALayer *bottomBorder3 = [CALayer layer];
    bottomBorder3.frame = CGRectMake(0.0f, self.firstName.frame.size.height - 1, self.firstName.frame.size.width - 1, 1.0f);
    bottomBorder3.backgroundColor = [UIColor grayColor].CGColor;
    bottomBorder3.borderWidth = 2 ;
    

    
    [self.firstName.layer addSublayer:bottomBorder];
    [self.lastName.layer addSublayer:bottomBorder2];
    [self.middleName.layer addSublayer:bottomBorder3];

}






#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showBackgroundInfo"]) {
        UINavigationController *navi = segue.destinationViewController;
        BackgroundInfoViewController *backgroundInfoViewController = (BackgroundInfoViewController *)navi.topViewController;
        backgroundInfoViewController.patientInfo = self.patientInfo;
    }
}

@end
