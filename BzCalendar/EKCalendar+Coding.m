//
//  EKCalendar+Coding.m
//  BzCalendar
//
//  Created by 小林 活水 on 11/12/31.
//  Copyright (c) 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "EKCalendar+Coding.h"
#import "CalendarManager.h"

@implementation EKCalendar (Coding)

- (void)encodeWithCoder:(NSCoder *)encoder {
    float vertion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if( vertion < 5.0 ) {
        [encoder encodeObject:[self calendarIdentifier] 
                       forKey:@"calendarIdentifier"];
        [encoder encodeObject:[self title] forKey:@"title"];
        

    } else {
        [encoder encodeObject:nil 
                       forKey:@"calendarIdentifier"];
        [encoder encodeObject:[self title] forKey:@"title"];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    NSString* calendarIdentifier = [decoder decodeObjectForKey:@"calendarIdentifier"];
    NSString* title = [decoder decodeObjectForKey:@"title"];
    
    EKEventStore* store = [[CalendarManager sharedManager] appEventStore];
    if( calendarIdentifier ) {
        self = [store calendarWithIdentifier:calendarIdentifier];
        
    } else {
        NSArray* calendars = [store calendarsForEntityType:EKEntityTypeEvent];
        for( EKCalendar* cal in calendars ) {
            if( [[cal title] compare:title] == NSOrderedSame ) {
                self = cal;
                
                break;
            }
        }
    }
    
    return self;
    
}

@end
