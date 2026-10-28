//
//  AppEventKit.h
//  GSystemT0
//
//  Created by 小林 活水 on 11/01/03.
//  Copyright 2011 Katsumi KOBAYASHI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface AppEventKit : NSObject {
	
}

+(AppEventKit*) sharedEventKit;

-(EKEventStore*) store;

-(NSArray<EKEvent*>*) eventsFrom:(NSDate*)fromDate to:(NSDate*)toDate calendars:(NSArray*)calendars;

-(EKEvent*) newEvent;

//-(BOOL) cancelNewEvent;
//-(BOOL) saveNewEventAndReleaseInstance;

@end
