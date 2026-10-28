//
//  EKRecurrenceRule+Coding.m
//  BzCalendar
//
//  Created by 小林 活水 on 11/12/29.
//  Copyright (c) 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "EKRecurrenceRule+Coding.h"

@implementation EKRecurrenceRule (Coding)

- (void)encodeWithCoder:(NSCoder *)encoder {

    [encoder encodeInteger:[self frequency] forKey:@"frequency"];
    [encoder encodeInteger:[self interval] forKey:@"interval"];

    [encoder encodeObject:[self daysOfTheMonth] forKey:@"daysOfTheMonth"];
    [encoder encodeObject:[self daysOfTheWeek] forKey:@"daysOfTheWeek"];

    [encoder encodeObject:[self monthsOfTheYear] forKey:@"monthsOfTheYear"];
    [encoder encodeObject:[self weeksOfTheYear] forKey:@"weeksOfTheYear"];
    [encoder encodeObject:[self daysOfTheYear] forKey:@"daysOfTheYear"];
    [encoder encodeObject:[self setPositions] forKey:@"setPositions"];

    [encoder encodeObject:[self recurrenceEnd] forKey:@"recurrenceEnd"];

    
}

- (id)initWithCoder:(NSCoder *)decoder {

    NSInteger frequency = [decoder decodeIntegerForKey:@"frequency"];
    NSInteger interval = [decoder decodeIntegerForKey:@"interval"];
    NSArray* daysOfTheMonth = [decoder decodeObjectForKey:@"daysOfTheMonth"];
    NSArray* daysOfTheWeek = [decoder decodeObjectForKey:@"daysOfTheWeek"];
    NSArray* monthsOfTheYear = [decoder decodeObjectForKey:@"monthsOfTheYear"];
    NSArray* weeksOfTheYear = [decoder decodeObjectForKey:@"weeksOfTheYear"];
    NSArray* daysOfTheYear = [decoder decodeObjectForKey:@"daysOfTheYear"];
    NSArray* setPositions = [decoder decodeObjectForKey:@"setPositions"];
    EKRecurrenceEnd* end = [decoder decodeObjectForKey:@"recurrenceEnd"];
    
    self = [self initRecurrenceWithFrequency:frequency
                                     interval:interval
                                daysOfTheWeek:daysOfTheWeek
                               daysOfTheMonth:daysOfTheMonth
                              monthsOfTheYear:monthsOfTheYear
                               weeksOfTheYear:weeksOfTheYear
                                daysOfTheYear:daysOfTheYear
                                 setPositions:setPositions
                                          end:end];


    return self;

}

@end
