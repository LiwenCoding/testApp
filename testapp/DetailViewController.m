//
//  DetailViewController.m
//  testapp
//
//  Created by Shen Liwen on 4/21/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
//    self.nameLabel.text = self.date;
//    NSLog(@"date is : %@", self.date);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDate:(NSString *)date {
    
    if (_date != date) {
        _date = date;
    }
    [self configureView];

}



- (void)configureView {
    // Update the user interface for the detail item.
        self.nameLabel.text = self.date;
    
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
