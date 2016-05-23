//
//  PhotoViewController.m
//  testapp
//
//  Created by Shen Liwen on 5/20/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "PhotoViewController.h"
#import "NameViewController.h"

@interface PhotoViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    //        [self.spinner startAnimating];
            NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
            NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
                if (!error) {
                    if ([request.URL isEqual:imageURL]) {
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.imageView.image = image;
                        });
                    }
                }
            }];
            [task resume];
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
