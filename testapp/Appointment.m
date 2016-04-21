//
//  Appointment.m
//  testapp
//
//  Created by Shen Liwen on 4/21/16.
//  Copyright © 2016 Shen Liwen. All rights reserved.
//

#import "Appointment.h"

@implementation Appointment

-(id)initWithPatientId:(NSNumber *)patientId withDate:(NSString *)date withReason:(NSString *) reason {

    self = [super init];
    if (self) {
        _patientId = patientId;
        _date = date;
        _reason = reason;
    }
    return self;
}

@end
