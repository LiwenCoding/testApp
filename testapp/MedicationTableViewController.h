//
//  MedicationTableViewController.h
//  testapp
//
//  Created by Shen Liwen on 5/22/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedicationTableViewController : UITableViewController
@property(strong, nonatomic)NSMutableDictionary *patientInfo;
@property (strong, nonatomic) NSArray *allergyArray;

@end