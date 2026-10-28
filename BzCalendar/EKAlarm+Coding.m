//
//  EKAlarm+Coding.m
//  BzCalendar
//
//  Created by 小林 活水 on 11/12/31.
//  Copyright (c) 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "EKAlarm+Coding.h"

@implementation EKAlarm (Coding)

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:[self absoluteDate] forKey:@"absoluteDate"];
    [encoder encodeDouble:[self relativeOffset] forKey:@"relativeOffset"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    NSDate* absoluteDate = [decoder decodeObjectForKey:@"absoluteDate"];
    if( absoluteDate ) {
        self = [EKAlarm alarmWithAbsoluteDate:absoluteDate];
        
    } else {
        NSTimeInterval interval = [decoder decodeDoubleForKey:@"relativeOffset"];
        self = [EKAlarm alarmWithRelativeOffset:interval];
            }
    
    return self;    
}

@end
