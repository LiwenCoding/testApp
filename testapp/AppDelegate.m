//
//  AppDelegate.m
//  testapp
//
//  Created by Shen Liwen on 4/20/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    
    NSString *query = [url query];
    NSString *accessToken = [[query componentsSeparatedByString: @"="] objectAtIndex:1];
    NSString *headerValue = [NSString stringWithFormat:@"Bearer %@", accessToken];
//    NSLog(@"URL parameters:%@", headerValue);

//    NSString *urlString = [NSString stringWithFormat: @"https://liwen.drchrono.com/o/token/?%@&grant_type=authorization_code&redirect_uri=http%%3A%%2F%%2F127.0.0.1%%3A8000%%2FGroupOrder%%2Fdefault%%2Ftest&client_id=V7jV4QDuGHjSMtIFc3BW4Rdaf4k1N2focgvGTxpj&client_secret=05iKwS5NINtEo9YNNM83Ut6ofv8FPZhU9HMppKYP6SElXrVAw8qIJnWJQUcQJEj2oreSy59roSm1cJ7Lz1VKl3mkLaZe1aX0GXsMzdjO7SQVwqxw6WqXh2oGCSWWqDoQ", query];
//    
//    NSLog(@"urlstring is: %@", urlString);
//    
//    NSData *Rawdata = [NSData dataWithContentsOfURL: [NSURL URLWithString:urlString]];
////    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:Rawdata options:kNilOptions error: NULL];
//    NSLog(@"data i s : %@", Rawdata);

//    NSString *post = [NSString stringWithFormat:@"Username=%@&Password=%@",@"username",@"password"];
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//
//    [request setURL:[NSURL URLWithString:@"https://drchrono.com/api/users/current"]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:headerValue forHTTPHeaderField:@"Authorization"];
//    [request setHTTPBody:postData];
    
//    NSString *post = [NSString stringWithFormat:@"test=Message&this=isNotReal"];
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    
//    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
//
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:@"http://YourURL.com/FakeURL"]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setHTTPBody:postData];
//    
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//        NSLog(@"requestReply: %@", requestReply);
//    }] resume];
////

//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    NSDate *date = [NSDate date];
//    NSString *dateString = [[[date description] componentsSeparatedByString: @" "] objectAtIndex:0];
//    NSLog(@"date is : %@", dateString);
//    NSString *appointmentURLString = [NSString stringWithFormat:@"https://drchrono.com/api/appointments?date=%@", dateString];
//    NSLog(@"url is : %@", appointmentURLString);
//    [request setURL:[NSURL URLWithString:appointmentURLString]];
//    
//    
//    
//    
//    
//    
//    
//    
////    [request setURL:[NSURL URLWithString:@"https://drchrono.com/api/patients"]];
//    [request setHTTPMethod:@"GET"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:headerValue forHTTPHeaderField:@"Authorization"];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSDictionary *requestReply = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error: &error];
//
////        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//        NSLog(@"requestReply: %@", requestReply);
//    }] resume];
    
    [[NSUserDefaults standardUserDefaults] setValue:headerValue forKey:@"headerValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    return YES;

}





@end
