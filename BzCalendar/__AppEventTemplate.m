//
//  AppEventTemplate.m
//  BzCalendar
//
//  Created by 小林 活水 on 11/12/29.
//  Copyright (c) 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import "AppEventTemplate.h"
#import "CalendarManager.h"

#import "BzCalendar-Swift.h"

@interface AppEventTemplate() 

@property(nonatomic, retain) CDEventTemplate* _cdEventTemplate;

@end

@implementation AppEventTemplate

@synthesize _cdEventTemplate;

@synthesize templateGroupName;
@synthesize templateName;
@synthesize title;
@synthesize allDay;
@synthesize location;
@synthesize notes;
@synthesize calendar;

@synthesize alarms;
@synthesize availability;

@synthesize status;

@synthesize attendees;         // array of EKParticipant
@synthesize organizer;

@synthesize startTimeComps;
@synthesize eventLengthComps;

// iOS 5
@synthesize recurrenceRules;
@synthesize timeZone;

@synthesize customColor;
@synthesize customTextColor;

- (id) init {
    self = [super init];
    if( self ) {
        self.templateGroupName = nil;
        self.templateName = nil;
        self.title = nil;
        self.startTimeComps = nil;

    }
    return self;
}
- (id) initWithEvent:(EKEvent *)event {
    self = [super init];
    if( self ) {
        self._cdEventTemplate = nil;

        self.templateGroupName = @"";
        self.templateName = event.title;
        self.title = event.title;
        self.allDay = event.allDay;
        self.location = event.location;
        self.notes = event.notes;
        self.calendar = event.calendar;
        self.alarms = event.alarms;
        self.availability = event.availability;
        self.status = event.status;
        self.attendees = event.attendees;
        self.organizer = event.organizer;
            
        self.recurrenceRules = event.recurrenceRules;
        
        self.timeZone = event.timeZone;
        
        NSCalendar* appCalendar = [[CalendarManager sharedManager] appCalendar];
        NSUInteger unitFlag = NSCalendarUnitHour | NSCalendarUnitMinute;
        if( self.allDay != YES ) {
            self.startTimeComps = [appCalendar components:unitFlag fromDate:event.startDate];
            self.eventLengthComps = [appCalendar components:unitFlag fromDate:event.startDate toDate:event.endDate options:0];
        } else {
            self.startTimeComps = nil;
            self.eventLengthComps = nil;
        }
        
        self.customColor = nil;
        self.customTextColor = nil;

        EventExtension* extension = [[BzEventExtensionService shared] eventExtensionWithEvent:event];
        if( extension != nil ) {
            if( extension.bgColorCode ) {
                self.customColor = [[ColorUtil shared] UIColorFromColorCode:extension.bgColorCode];
            }
            if( extension.textColorCode ) {
                self.customTextColor = [[ColorUtil shared] UIColorFromColorCode:extension.textColorCode];
            }
        }

    }
    return self;
}
- (id) initWithOtherTemplate:(AppEventTemplate*)other {
    self = [super init];
    if( self ) {
        [self setCDEventTemplate:other.cdEventTemplate];
        self.templateGroupName = other.templateGroupName;
        self.templateName = other.templateName;
        self.title = other.title;
        self.allDay = other.allDay;
        self.location = other.location;
        self.notes = other.notes;
        self.calendar = other.calendar;
        self.alarms = other.alarms;
        self.availability = other.availability;
        self.status = other.status;
        self.attendees = other.attendees;
        self.organizer = other.organizer;
        self.recurrenceRules = other.recurrenceRules;
        self.timeZone = other.timeZone;
        self.startTimeComps = other.startTimeComps;
        self.eventLengthComps = other.eventLengthComps;

        self.customColor = other.customColor;
        self.customTextColor = other.customTextColor;
    }
    return self;
}
- (id) initWithCoreData:(CDEventTemplate*)cdTemplate {
    self = [super init];
    if( self ) {
        self._cdEventTemplate = cdTemplate;
        
        self.templateGroupName = @"";
        self.templateName = cdTemplate.templateName;
        self.title = cdTemplate.title;
        self.allDay = [cdTemplate.allDay boolValue];
        self.location = cdTemplate.location;
        self.notes = cdTemplate.notes;
        EKEventStore* store = [[AppEventKit shared] store];
        
        self.calendar = [store calendarWithIdentifier:cdTemplate.calendarIdentifier];
        
        if( self.calendar == nil) {
            self.calendar = [store defaultCalendarForNewEvents];
        }
        if( cdTemplate.alarmsData ) {
            self.alarms = [NSKeyedUnarchiver unarchiveObjectWithData:cdTemplate.alarmsData];
        } else {
            self.alarms = nil;
        }
        self.availability = [cdTemplate.availability intValue];
        self.status = [cdTemplate.status intValue];
        if( cdTemplate.attendeesData ) {
            self.attendees = [NSKeyedUnarchiver unarchiveObjectWithData:cdTemplate.attendeesData];
        } else {
            self.attendees = nil;
        }
        if( cdTemplate.organizerData ) {
            self.organizer = [NSKeyedUnarchiver unarchiveObjectWithData:cdTemplate.organizerData];
        } else {
            self.organizer = nil;
        }
        if( cdTemplate.recurrenceRulesData ) {
            self.recurrenceRules = [NSKeyedUnarchiver unarchiveObjectWithData:cdTemplate.recurrenceRulesData];
        } else {
            self.recurrenceRules = nil;
        }
        if( cdTemplate.timeZoneData ) {
            self.timeZone = [NSKeyedUnarchiver unarchiveObjectWithData: cdTemplate.timeZoneData];
        } else {
            self.timeZone = nil;
        }
        if( cdTemplate.startTimeCompsData ) {
            self.startTimeComps = [NSKeyedUnarchiver unarchiveObjectWithData:cdTemplate.startTimeCompsData];
        } else {
            self.startTimeComps = nil;
        }
        if (self.allDay == FALSE) {
            self.eventLengthComps = [NSKeyedUnarchiver unarchiveObjectWithData:cdTemplate.eventLengthCompsData];
        } else {
            self.eventLengthComps = nil;
        }
        self.customColor = nil;
        if( cdTemplate.bgColorCode ) {
            self.customColor = [[ColorUtil shared] UIColorFromColorCode:cdTemplate.bgColorCode];
        }    
        self.customTextColor = nil;
        if( cdTemplate.textColorCode ) {
            self.customTextColor = [[ColorUtil shared] UIColorFromColorCode:cdTemplate.textColorCode];
        }
    }
    return self;
}

- (void) setCDEventTemplate:(CDEventTemplate*)cdTemplate {
    self._cdEventTemplate = cdTemplate;
}
- (CDEventTemplate*) cdEventTemplate {
    return self._cdEventTemplate;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:templateGroupName forKey:@"templateGroupName"];
    [encoder encodeObject:templateName forKey:@"templateName"];
    [encoder encodeObject:title forKey:@"title"];
    [encoder encodeBool:allDay forKey:@"allDay"];
    [encoder encodeObject:location forKey:@"location"];
    [encoder encodeObject:notes forKey:@"notes"];
    [encoder encodeObject:calendar forKey:@"calendar"];
    [encoder encodeObject:alarms forKey:@"alarms"];
    [encoder encodeInteger:availability forKey:@"availability"];
    [encoder encodeInteger:status forKey:@"status"];
    [encoder encodeObject:attendees forKey:@"attendees"];
    //[encoder encodeObject:nil forKey:@"organizer"];
    [encoder encodeObject:recurrenceRules forKey:@"recurrenceRules"];
    [encoder encodeObject:timeZone forKey:@"timeZone"];
    
    NSString* colorCd = nil;
    if( self.customColor ) {
        colorCd = [[ColorUtil shared] colorCodeWithColor:self.customColor];
    }
    [encoder encodeObject:colorCd forKey:@"bgColorCode"];
    NSString* colorTextCd = nil;
    if( self.customTextColor ) {
        colorTextCd = [[ColorUtil shared] colorCodeWithColor:self.customTextColor];
    }
    [encoder encodeObject:colorTextCd forKey:@"textColorCode"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    if( self ) {
        self.templateGroupName = [decoder decodeObjectForKey:@"templateGroupName"];
        self.templateName = [decoder decodeObjectForKey:@"templateName"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.allDay = [decoder decodeBoolForKey:@"allDay"];
        self.location = [decoder decodeObjectForKey:@"location"];
        self.notes = [decoder decodeObjectForKey:@"notes"];
        self.calendar = [decoder decodeObjectForKey:@"calendar"];
        self.alarms = [decoder decodeObjectForKey:@"alarms"];
        self.availability = [decoder decodeIntegerForKey:@"availability"];
        self.status = [decoder decodeIntegerForKey:@"status"];
        self.attendees = [decoder decodeObjectForKey:@"attendees"];
        self.recurrenceRules = [decoder decodeObjectForKey:@"recurrenceRules"];
        self.timeZone = [decoder decodeObjectForKey:@"timeZone"];
        NSString* colorCd = [decoder decodeObjectForKey:@"bgColorCode"];
        if( colorCd ) {
            self.customColor = [[ColorUtil shared] UIColorFromColorCode:colorCd];
        } else {
            self.customColor = nil;
        }
        NSString* textColorCd = [decoder decodeObjectForKey:@"textColorCode"];
        if( textColorCd ) {
            self.customTextColor = [[ColorUtil shared] UIColorFromColorCode:textColorCd];
        } else {
            self.customTextColor = nil;
        }
    }
    
    return self;    
}
 

@end
