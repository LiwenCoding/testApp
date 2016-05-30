//
//  ReasonViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/29/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "ReasonViewController.h"

@interface ReasonViewController ()
@property (weak, nonatomic) IBOutlet UITextView *note;
@property (weak, nonatomic) IBOutlet UISwitch *allergy;
@property (weak, nonatomic) IBOutlet UISwitch *headache;
@property (weak, nonatomic) IBOutlet UILabel *fever;
@property (weak, nonatomic) IBOutlet UISwitch *cold;
@property (weak, nonatomic) IBOutlet UISwitch *dizzy;
@property (weak, nonatomic) IBOutlet UILabel *other;

@end

@implementation ReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.note.layer.cornerRadius = 5.0;
    self.note.clipsToBounds = YES;
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
