//
//  EthnicitySelectionTableViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/21/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "EthnicitySelectionTableViewController.h"

@interface EthnicitySelectionTableViewController ()
@property (strong, nonatomic)NSArray *ethnicityArray;

@end

@implementation EthnicitySelectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ethnicityArray =  @[@"Hispanic or Latino", @"Not Hispanic or Latino", @"Declined to State"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.ethnicityArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ethnicity" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.ethnicityArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedString = [self.ethnicityArray objectAtIndex:indexPath.row];
    NSLog(@"selected is %@", selectedString);
    self.selectionHappenedInPopoverVC(selectedString);
    
}


@end
