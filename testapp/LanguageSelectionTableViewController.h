//
//  LanguageSelectionTableViewController.h
//  testapp
//
//  Created by Shen Liwen on 5/21/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LanguageSelectionTableViewController : UITableViewController
@property (nonatomic, copy) void (^selectionHappenedInPopoverVC)(NSString *responseLanguage);

@end