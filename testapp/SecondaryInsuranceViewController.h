//
//  SecondaryInsuranceViewController.h
//  testapp
//
//  Created by Shen Liwen on 5/22/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "ViewController.h"

@interface SecondaryInsuranceViewController : ViewController
@property(strong, nonatomic)NSMutableDictionary *patientInfo;
@property (strong, nonatomic) NSMutableString *reason;
@property (strong, nonatomic) NSMutableString *notes;
@property (strong, nonatomic) NSString *appointmentId;
@end
