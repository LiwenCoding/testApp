//
//  Appointment.h
//  testapp
//
//  Created by Shen Liwen on 4/21/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Appointment : NSObject
@property (strong, nonatomic) NSNumber *patientId;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *reason;

-(id)initWithPatientId:(NSNumber *)patientId withDate:(NSString *)date withReason:(NSString *)reason;
@end
