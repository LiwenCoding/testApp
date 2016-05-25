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
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
