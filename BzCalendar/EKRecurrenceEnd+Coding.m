//
//  EKRecurrenceEnd+Coding.m
//  BzCalendar
//
//  Created by 小林 活水 on 11/12/29.
//  Copyright (c) 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "EKRecurrenceEnd+Coding.h"

@implementation EKRecurrenceEnd (Coding)
- (void)encodeWithCoder:(NSCoder *)encoder {
    
    if( [self endDate] != nil ) {
        [encoder encodeObject:[self endDate] forKey:@"endDate"];
        [encoder encodeInteger:-1 forKey:@"occurrenceCount"];
    } else {
        [encoder encodeObject:nil forKey:@"endDate"];
        NSInteger count = (NSInteger)[self occurrenceCount];
        [encoder encodeInteger:count forKey:@"occurrenceCount"];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    NSInteger occurrenceCount = [decoder decodeIntegerForKey:@"occurrenceCount"];
    NSDate* endDate = [decoder decodeObjectForKey:@"endDate"];
    
    if( endDate != nil ) {
        self = [EKRecurrenceEnd recurrenceEndWithEndDate:endDate];
    } else {
        self = [EKRecurrenceEnd recurrenceEndWithOccurrenceCount:(NSUInteger)occurrenceCount];
    }
   
    return self;
    
}


@end
