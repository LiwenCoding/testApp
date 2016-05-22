//
//  RaceSelectionTableViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/21/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "RaceSelectionTableViewController.h"

@interface RaceSelectionTableViewController ()
@property (strong, nonatomic)NSArray *raceArray;

@end

@implementation RaceSelectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.raceArray =  @[@"American Indian or Alaska Native", @"Asian", @"Black or African American", @"Native Hawaiian or Other Pacific Islander", @"White", @"Other", @"Unknown", @"Declined to State"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.raceArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"race" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.raceArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedString = [self.raceArray objectAtIndex:indexPath.row];
    NSLog(@"selected is %@", selectedString);
    self.selectionHappenedInPopoverVC(selectedString);
    
}


@end