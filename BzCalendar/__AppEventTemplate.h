//
//  AppEventTemplate.h
//  BzCalendar
//
//  Created by 小林 活水 on 11/12/29.
//  Copyright (c) 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
//#import "CDEventTemplate.h"

@class CDEventTemplate;

@interface AppEventTemplate : NSObject <NSCoding>{
//    NSString* templateGroupName;
//    NSString* templateName;
//    
//    NSString* title;
//    BOOL allDay;
//    NSString* location;
//    NSString* notes;
//    EKCalendar* calendar;
//    
//    NSArray* alarms;
//    EKEventAvailability availability;
//
//    EKEventStatus status;
//
//    NSArray* attendees;         // array of EKParticipant
//    EKParticipant* organizer;
//    
//    NSDateComponents* startTimeComps;
//    
//    NSDateComponents* eventLengthComps;
//    
//    
//    // iOS 5
//    NSArray* recurrenceRules;
//    NSTimeZone *timeZone;
//    
//    CDEventTemplate* _cdEventTemplate;
//    
//    UIColor* customColor;
//    UIColor* customTextColor;

}

@property (nonatomic, retain) NSString* templateGroupName;
@property (nonatomic, retain) NSString* templateName;

@property (nonatomic, retain)   NSString* title;
@property (nonatomic)  BOOL allDay;
@property (nonatomic, retain)  NSString* location;
@property (nonatomic, retain)  NSString* notes;
@property (nonatomic, retain)  EKCalendar* calendar;

@property (nonatomic, retain) NSArray* alarms;
@property (nonatomic)  EKEventAvailability availability;

@property (nonatomic)  EKEventStatus status;

@property (nonatomic, retain) NSArray* attendees;         // array of EKParticipant
@property (nonatomic, retain) EKParticipant* organizer;

@property (nonatomic, retain) NSDateComponents* startTimeComps;
@property (nonatomic, retain) NSDateComponents* eventLengthComps;


// iOS 5
@property (nonatomic, retain)  NSArray* recurrenceRules;
@property (nonatomic, retain)  NSTimeZone *timeZone;

@property (nonatomic, retain) UIColor* customColor;
@property (nonatomic, retain) UIColor* customTextColor;

- (id) initWithEvent:(EKEvent*)event;
- (id) initWithOtherTemplate:(AppEventTemplate*)other;
- (id) initWithCoreData:(CDEventTemplate*)cdTemplate;
- (void) setCDEventTemplate:(CDEventTemplate*)cdTemplate;
- (CDEventTemplate*) cdEventTemplate;

@end
