//
//  LanguageSelectionTableViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/21/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "LanguageSelectionTableViewController.h"

@interface LanguageSelectionTableViewController ()
@property (strong, nonatomic)NSArray *languageArray;
@property (strong, nonatomic)NSArray *selectionArray;
@end

@implementation LanguageSelectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.barStyle  = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:44.0/255.0 green:192.0/255.0 blue:83.0/255.0 alpha:1];
    self.languageArray =  @[@"English", @"Spanish", @"Chinese", @"French", @"Italian", @"Japanese", @"Portuguese", @"Russian", @"Other"];
    self.selectionArray =  @[@"eng", @"spa", @"zho", @"fra", @"ita", @"jpe", @"por", @"rus", @"other"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.languageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"language" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.languageArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedString = [self.selectionArray objectAtIndex:indexPath.row];
    self.selectionHappenedInPopoverVC(selectedString);
}

@end
