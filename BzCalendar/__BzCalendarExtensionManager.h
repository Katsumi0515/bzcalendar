//
//  BzCalendarExtensionManager.h
//  BzCalendar
//
//  Created by 小林 活水 on 12/02/10.
//  Copyright (c) 2012年 Katsumi KOBAYASHI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@class CalendarExtension;

@interface BzCalendarExtensionManager : NSObject {}

+ (BzCalendarExtensionManager*) sharedManager;

- (void) setPrivateContext:(NSManagedObjectContext*)privateContext;


- (CalendarExtension*) addExtensionTo:(EKCalendar*)calendar;
- (CalendarExtension*) getExtensionOf:(EKCalendar*)calendar;

- (void)clearCache:(void (^)(NSError* error))completionHandler;

- (void)saveAllChangesInContext:(void (^)(NSError* error))completionHandler;

@end
