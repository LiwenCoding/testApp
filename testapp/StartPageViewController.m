//
//  StartPageViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/16/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "StartPageViewController.h"

@interface StartPageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *checkInButton;
@end

@implementation StartPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.toolbarHidden = YES;
    self.checkInButton.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
