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
#import "RKDropdownAlert.h"

@interface PhotoViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *takePhoto;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@end

@implementation PhotoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startDownloadingImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.takePhoto.layer.cornerRadius = 5;
    self.next.layer.cornerRadius = 5;
    self.cancel.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)startDownloadingImage {
    if(![[self.patientInfo objectForKey:@"patient_photo"] isEqual:[NSNull null]]) {
        NSURL *imageURL = [NSURL URLWithString:[self.patientInfo objectForKey:@"patient_photo"]];
        if (imageURL) {
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

- (IBAction)takePhotoButtonPressed:(id)sender {
    [RKDropdownAlert title:@"Hodor" message:@"Coming soon!" backgroundColor:[UIColor colorWithRed:44.0/255.0 green:192.0/255.0 blue:83.0/255.0 alpha:0.8] textColor:[UIColor whiteColor] time:3];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self alert];
}

#pragma mark - alert

- (void)alert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"If continue, all saved information will be lost" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:@"home1" sender:self];
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"nameInfo"]) {
        NameViewController *vc = segue.destinationViewController;
        vc.patientInfo = self.patientInfo;
        vc.reason = self.reason;
        vc.notes = self.notes;
        vc.appointmentId = self.appointmentId;
    }
}

@end
