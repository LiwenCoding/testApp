//
//  AllergyTableViewCell.h
//  testapp
//
//  Created by Shen Liwen on 5/22/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllergyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *allergyDescription;

@property (weak, nonatomic) IBOutlet UILabel *reaction;

@end
