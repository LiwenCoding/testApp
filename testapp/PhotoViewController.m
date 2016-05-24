//
//  PhotoViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/20/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "PhotoViewController.h"
#import "NameViewController.h"
#import "MBProgressHUD.h"

@interface PhotoViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.barStyle  = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:44.0/255.0 green:192.0/255.0 blue:83.0/255.0 alpha:1];
    NSLog(@"patient info recieved: %@", self.patientInfo);
    [self startDownloadingImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)startDownloadingImage {
    
    if(![[self.patientInfo objectForKey:@"patient_photo"] isEqual:[NSNull null]]) {
        NSURL *imageURL = [NSURL URLWithString:[self.patientInfo objectForKey:@"patient_photo"]];
        if (imageURL) {
            //show progress indicator
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.label.text = @"Loading...";
            NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
            
            dispatch_queue_t fetchQ = dispatch_queue_create("fetcher", NULL);
            dispatch_async(fetchQ, ^{
                NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
                NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
                    if (!error) {
                        if ([request.URL isEqual:imageURL]) {
                            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                self.imageView.image = image;
                            });
                        }
                    }
                }];
                [task resume];
            });
        }
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"nameInfo"]) {
        UINavigationController *navi = segue.destinationViewController;
        NameViewController *vc = (NameViewController *)navi.topViewController;
        vc.patientInfo = self.patientInfo;
    }
}

@end
