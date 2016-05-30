//
//  FinishViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/23/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "FinishViewController.h"

@interface FinishViewController ()
@property (weak, nonatomic) IBOutlet UIButton *exit;
@end

@implementation FinishViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.exit.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
